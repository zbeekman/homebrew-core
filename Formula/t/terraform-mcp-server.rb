class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "8c744e2ad553ee37db41b66a0f2dbb6532939c00e17b5f00bd10f5809f6f3990"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52a178aab4ee378a27b9c25f9c8f1e528feeda0d0946d886130372fa1ed773b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52a178aab4ee378a27b9c25f9c8f1e528feeda0d0946d886130372fa1ed773b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52a178aab4ee378a27b9c25f9c8f1e528feeda0d0946d886130372fa1ed773b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d1d072d1f7dcb971d59ceb8a470b5d0174b8a8974136868700ffc0ee60ee286a"
    sha256 cellar: :any,                 x86_64_linux:      "20f88c9a3bc8b0fbb051fa5367063b54e607c70d136a49e365cb11ffb0d1cec7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/hashicorp/terraform-mcp-server/version.GitCommit=#{tap.user}
      -X github.com/hashicorp/terraform-mcp-server/version.BuildDate=#{time.iso8601}
      -X github.com/hashicorp/terraform-mcp-server/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/terraform-mcp-server"
    generate_completions_from_executable(bin/"terraform-mcp-server", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terraform-mcp-server --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"terraform-mcp-server", json, 0)
    assert_match "Fetches the latest version of a Terraform module from the public registry", output
  end
end
