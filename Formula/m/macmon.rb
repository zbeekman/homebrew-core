class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "3c7dcff34813bc09f50d5cf077e17ba6e8ca1d8a7509513d07597303b37a10e7"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9484530b11b84f3f9aafa1e5f1d7c582f936cc42a0ed745beabfa8aeeff349b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a74c80682a02a178d04e31f58deae189e2fd763023e8256adbdfa5740fa39294"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6eccaa90ad2ba96bb72742c22e0c1dbe5cab266e55c1ada99f9d10aefc3a43cc"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
    assert_match "hw.nperflevels", shell_output("#{bin}/macmon debug 2>&1")
  end
end
