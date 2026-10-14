class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.4.0.tgz"
  sha256 "1b94f20509ba1328cb02326d0fa4c48ffb42887c635f0421b438ef8404cc9f30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0776b2d41852963309c6748988eab2baa62e2bd5276558149c4ee128f7859bbf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"context7-mcp", json, 0)
    assert_match "resolve-library-id", output
  end
end
