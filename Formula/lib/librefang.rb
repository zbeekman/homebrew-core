class Librefang < Formula
  desc "Self-hostable operating system for autonomous AI agents"
  homepage "https://librefang.ai"
  url "https://github.com/librefang/librefang/archive/refs/tags/v2026.10.16.tar.gz"
  sha256 "513c4310967d66f7e3346384323ab3a26ec191cf9e3c75ad7cac44003fae3f74"
  license "MIT"
  head "https://github.com/librefang/librefang.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "af1b5530b60f22288731f12dd62fc9fef29517450b02886e28ecde303dc0eb12"
    sha256 cellar: :any, arm64_tahoe:       "3c9a732e2dd6a30f3fc0dac5c94c2662355c577bfac5e25c92eee2acd4fb8a0e"
    sha256 cellar: :any, arm64_sequoia:     "8ba47166ba76449da3567b0504e67791e10227b3445b9fbdb6c2d861cb4e1e9c"
    sha256 cellar: :any, arm64_linux:       "e67ee26352cf99e359cec7c411f5003ed0bc638e1d488d385061719e35c8d34f"
    sha256 cellar: :any, x86_64_linux:      "d3cdfe37535cf2123ed823bc16dc3dfb2ee619d67d92b0a077a60c7b2f05d8f6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "dbus"
  end

  # Support Rust 1.99+
  patch do
    url "https://github.com/librefang/librefang/commit/2d0e85b0d6755aa928f552116ac9680c4eb16d26.patch?full_index=1"
    sha256 "2c6aaad8951e2f8adfc4293f147c15ebb4bf7dd1a0acaa97ccbda1c5303ec0df"
    type :unofficial
    resolves "https://github.com/librefang/librefang/pull/8635"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Fat LTO exceeds the memory available on hosted Linux ARM64 builders.
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    system "cargo", "install", *std_cargo_args(path: "crates/librefang-cli")
  end

  test do
    system bin/"librefang", "init", "--quick"
    assert_path_exists testpath/".librefang/config.toml"
  end
end
