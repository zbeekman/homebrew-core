class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.11.tar.gz"
  sha256 "adfe19dbcaeac04683959ad531c13e526eeafc266824a2e4e62f8c7660a83e09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6a34fde88abe7da04ff3613b38aa813e4c9f367e1ddd0bb2a1432da1f306dad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6a34fde88abe7da04ff3613b38aa813e4c9f367e1ddd0bb2a1432da1f306dad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f6a34fde88abe7da04ff3613b38aa813e4c9f367e1ddd0bb2a1432da1f306dad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5eab6e7acf3aadcf023f9f2ee3f2d314da3de6c7c83614b782b9e14e43de56d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9fec77cd00909bc316abbf05d887cea046aae37a6e904fc0318109e5cdeabfb9"
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
