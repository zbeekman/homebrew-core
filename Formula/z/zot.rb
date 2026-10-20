class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.38.tar.gz"
  sha256 "6d839e1e865a530cf2f81e1b52825c092fc29e84485f3bce7bc11f629e39888c"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a6ba8ce8030459ef6783c58c79bba2b3a92da2efd7c93a168d8b6c8e606ff0c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6ba8ce8030459ef6783c58c79bba2b3a92da2efd7c93a168d8b6c8e606ff0c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6ba8ce8030459ef6783c58c79bba2b3a92da2efd7c93a168d8b6c8e606ff0c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e444d84d4f0876897997f289581c64ac54be5431f99a02550b8e027698266a96"
    sha256 cellar: :any,                 x86_64_linux:      "30224f677a6142822b812ee23bd44b1471e7f657e3d3f9bbfbc2880bd0b144f8"
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
