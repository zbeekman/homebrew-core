class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.9.tar.gz"
  sha256 "529d41f6d9735c532ad77b93963c83af42e679a34830f987400b5129d6053e86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49b2393699431b122cc7c48f4dcd48373fc9853a14c3298e71c2f5763c76ff46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49b2393699431b122cc7c48f4dcd48373fc9853a14c3298e71c2f5763c76ff46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49b2393699431b122cc7c48f4dcd48373fc9853a14c3298e71c2f5763c76ff46"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "664185edc76d9e4e1bfbe958780bc4cae668e8ea97866457be42b6cc26ed0e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "575d291451c5c73bb27bdb7e59a553e4481db2970882fb66c6b5a87deb09e34e"
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
