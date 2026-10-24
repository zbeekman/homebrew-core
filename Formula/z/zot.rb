class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.47.tar.gz"
  sha256 "ef45743d23ea48a4f81ceb42a6c1df07d2da7b8b23a6b9e76946e75a4eae18da"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d8a64e5145ec594ac9604157e7a8767dc9baf7961c107711b85b0e0cbc6ed870"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8a64e5145ec594ac9604157e7a8767dc9baf7961c107711b85b0e0cbc6ed870"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d8a64e5145ec594ac9604157e7a8767dc9baf7961c107711b85b0e0cbc6ed870"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "50bf7131ce5a563714a6e9d75fcf92c2fa313e029b2db8fa857fbe36ac5f3f28"
    sha256 cellar: :any,                 x86_64_linux:      "e5be0873ba5d2f9f5034470080e2b5ccd99afce63868fc1d9424407ff7345559"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
