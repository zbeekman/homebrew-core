class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "22803dd59ab2f1e0c901606b6ef75080477ce1da44d15e5eac756dce4a128e34"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f9d64b3e172cf5731c103035c651b9a991e5a7399408213b9b6eaf09ec104f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f9d64b3e172cf5731c103035c651b9a991e5a7399408213b9b6eaf09ec104f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f9d64b3e172cf5731c103035c651b9a991e5a7399408213b9b6eaf09ec104f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "74485ebc2f8fb05fb41b75ad3ff23414606dfee0313723eb4eab1c10e062d40e"
    sha256 cellar: :any,                 x86_64_linux:      "c1a8f965f5026edcd96ceec4b9306b663d06a90115f8c7c13bf252f54d9a5675"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/github-mcp-server"

    generate_completions_from_executable(bin/"github-mcp-server", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
    JSON

    out = pipe_output("#{bin}/github-mcp-server stdio 2>&1", json)
    assert_includes out, "GitHub MCP Server running on stdio"
  end
end
