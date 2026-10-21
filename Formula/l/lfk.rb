class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.12.tar.gz"
  sha256 "b671a5b374bbe01533931b4f4d6f4f5f50c53d6fc15f4c7a9e0d8b174b9983a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58eb3f6bdaa84c3847953c0a634c72adab599b6336624d1c1e099809b18bc822"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58eb3f6bdaa84c3847953c0a634c72adab599b6336624d1c1e099809b18bc822"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58eb3f6bdaa84c3847953c0a634c72adab599b6336624d1c1e099809b18bc822"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cc3196211ecc90c4dfae573a2b2d3726943f40942fdfe81e5e0427303e2b0b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "31ca887d8dd37708c54eec6e5f5b43b8e9185be466b59ea15990f839e460d3dc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end
