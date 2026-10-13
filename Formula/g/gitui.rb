class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/gitui-org/gitui"
  url "https://github.com/gitui-org/gitui/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "0400cbf59605490b5fb8779f9af41fa4d7a1bb748093ca0e13156a5dff31c7aa"
  license "MIT"
  head "https://github.com/gitui-org/gitui.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "94363557c9932aa35e878d3fa2f8ff41d727e4bad9bf0d3df17dd22b538fa53d"
    sha256 cellar: :any,                 arm64_tahoe:       "8d680002eec562dc3e551b65df13870ed7c76f12137a47bd797b50bdcd2487d1"
    sha256 cellar: :any,                 arm64_sequoia:     "7cecc7faf77b0a9eb8263cf9bcbc9ac6c9066eafb065b4c6e43188572b9c3061"
    sha256 cellar: :any,                 arm64_sonoma:      "e4370bb36e12fd616f29ccd1159abe412e3196b3e8d758fdd1b6c04069d63cdd"
    sha256 cellar: :any,                 sonoma:            "a257d6363277574277a79ac33ec5ce1c9d97531b5137d4ef00d3fac4dd7793f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b81e6514a38501028d2e54c7d245ac376f2f5f6039e0f1b96ca1bafd5cc9fc01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c3776e0418c6233796021596efb33de72343bfd36f67c562c347642598d52253"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat" => :build # for libz-sys
  end

  # Apply open dependabot PR to update openssl-sys for OpenSSL 4 support
  patch do
    url "https://github.com/gitui-org/gitui/commit/f0cbe33cd72951c0faf877ac1531d3af8ba66d2a.patch?full_index=1"
    sha256 "5c75d06ce71366b575a8a7189d6f767833d630f028b4854b8307415d9ed83fd8"
    type :unofficial
    resolves "https://github.com/gitui-org/gitui/pull/2914"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "utils/linkage"

    system "git", "clone", "https://github.com/gitui-org/gitui.git"
    (testpath/"gitui").cd { system "git", "checkout", "v0.7.0" }

    output_log = testpath/"output.log"
    cmd_env = { "LC_CTYPE" => "en_US.UTF-8", "LANG" => "en_US.UTF-8", "TERM" => "xterm" }
    PTY.spawn(cmd_env, bin/"gitui", "-d", "gitui", [:out, :err] => output_log.to_s) do |r, w, pid|
      r.winsize = [80, 130]
      sleep 2
      # select log tab
      w.puts "2"
      sleep 2
      # inspect commit (return + right arrow key)
      w.puts "\r"
      sleep 2
      w.puts "\e[C"
      sleep 2
    ensure
      r.close
      w.close
      Process.kill "TERM", pid
      Process.wait pid
    end

    screenlog = output_log.read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub!(/\e\[([;\d]+)?m/, "")
    assert_match "Author: Stephan Dilly", screenlog
    assert_match "Date: 2020-06-15", screenlog
    assert_match "Sha: 9c2a31846c417d8775a346ceaf38e77b710d3aab", screenlog

    linked_libraries = [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
      formula_opt_lib("libssh2")/shared_library("libssh2"),
      formula_opt_lib("openssl@4")/shared_library("libssl"),
    ]
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"gitui", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
