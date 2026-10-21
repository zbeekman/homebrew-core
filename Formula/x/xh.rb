class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "8c54c7e8e878600d1a322151e0158c4fa6e6793283a45e355d0c1f87ca6d5640"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8127db20a02b32bfad9e7d96d2c7299bd6b169e66f33db859b862f5ea0fe3daa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d0e8c1d0310e6b2a692628ece06131afcfd8ccb6bcef9bed2ca60044d073df6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d4e4088d22998419a48bc55932cd4f838136c5cd96c90d21c1b5f98994d52c1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6e0a28c5d06c4fe1d0413466063cca1b06a465d6ce56cf6a558c2a776b880e59"
    sha256 cellar: :any_skip_relocation, sonoma:            "72e0506b810317c1da6775841545b22aef259860663bb25951d2789b019debdf"
    sha256 cellar: :any,                 arm64_linux:       "06d4bb935ad0f0820e43f45a7bf91430d55a2c3633b8bec73f7ab463f40cf68b"
    sha256 cellar: :any,                 x86_64_linux:      "c9f7ad71ebc63d83fa4efa47cae0d47838499c1f3765135f3bdca67ed14dacbf"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash" => "xh"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xh --version")
    assert_match "Accept-Encoding: gzip, deflate, br, zstd", shell_output("#{bin}/xh --offline https://httpbin.org/get")
  end
end
