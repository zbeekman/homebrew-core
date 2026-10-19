class LastpassCli < Formula
  desc "LastPass command-line interface tool"
  homepage "https://github.com/lastpass/lastpass-cli"
  url "https://github.com/lastpass/lastpass-cli/releases/download/v1.6.2/lastpass-cli-1.6.2.tar.gz"
  sha256 "b65b9c951a9a17b87b8ac0500808c716ef8e5fe6e70f1fd44f23b8385aa30984"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/lastpass/lastpass-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3437d7bef72b1030b6c7a89ed423a47362d4481f16f63c5241e9d63befac3cc2"
    sha256 cellar: :any, arm64_tahoe:       "6099e5ffa86169cf84aec8adfa829c3df3484a04a9cc64eb3e7a9e58a03ccd9e"
    sha256 cellar: :any, arm64_sequoia:     "ea654e3040dd92ab41e7808cf49634fa3106b75432729713af6829a2045d6932"
    sha256 cellar: :any, arm64_linux:       "916b5c33e8d986270868d5c078293dd3ee3fd260293a3995c366b9ac465c3b43"
    sha256 cellar: :any, x86_64_linux:      "66dfa43c1fc1efc6beb3443fa65211ae91b41df9bf8f8c3fb8eef74f7b9bc5ab"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "openssl@4"
  depends_on "pinentry"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  # Workaround for CMake 4 compatibility
  patch do
    url "https://github.com/lastpass/lastpass-cli/commit/31a4ad5f735933ff8e96403103d5b4f61faee945.patch?full_index=1"
    sha256 "a4c2a16fd47942a511c0ebbce08bee5ffdb0d6141f6c9b60ce397db9e207d8be"
    type :unofficial
    resolves "https://github.com/lastpass/lastpass-cli/pull/716"
  end

  deny_network_access!

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_MANDIR=#{man}", *std_cmake_args
    system "cmake", "--build", "build", "--target", "install", "--target", "install-doc"

    bash_completion.install "contrib/lpass_bash_completion"
    zsh_completion.install "contrib/lpass_zsh_completion" => "_lpass"
    fish_completion.install "contrib/completions-lpass.fish" => "lpass.fish"
  end

  test do
    mkdir testpath/".config/lpass"

    assert_equal("Error: Could not find decryption key. Perhaps you need to login with `#{bin}/lpass login`.",
      shell_output("#{bin}/lpass passwd 2>&1", 1).chomp)
  end
end
