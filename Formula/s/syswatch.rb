class Syswatch < Formula
  desc "Cross-platform system diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/syswatch"
  url "https://github.com/matthart1983/syswatch/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "390c0bf558e8c1859ffb77e05dcce47f7af073b26a38fc8800129c2d550ff44a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69cfefcbc5f84b8587c59e0375dc06a404ea22239cd0971aab0122d7ee5c907f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70c5772a613abf237028242b1024b03a517ba378d1fa3a009b44b86dbf9e4551"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "741f758c31aab04db749ee21798a3509d470e9ca9fd132792798f89d1a048056"
    sha256 cellar: :any,                 arm64_linux:       "af5781b323397c86e5f65c458a08f87ce2be8a18044136262b510e66b67d07f8"
    sha256 cellar: :any,                 x86_64_linux:      "88a6dfbf6088915c15b2d21d5e64daf502fcac36b1e412517c05689f01386736"
  end

  depends_on "rust" => :build

  on_macos do
    depends_on arch: :arm64 # test fails on Intel macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    ENV["TERM"] = "xterm"
    output_log = testpath/"output.log"
    PTY.spawn(bin/"syswatch", [:out, :err] => output_log.to_s) do |r, w, pid|
      r.winsize = [80, 130]
      sleep 2
      # bring up help dialog
      w.write "?"
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    output = output_log.read.scrub
    assert_match "Services", output
    # match text in help dialog
    assert_match "Procs tab", output
  end
end
