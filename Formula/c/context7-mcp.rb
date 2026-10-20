class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.4.4.tgz"
  sha256 "2ae37c3a2b41ff4d591a275ff1dc56883cb60bfc71e34c399c14ebd38837bb38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "317096c8fc28dbd8c423f8e41498030baa6950d74b9f58187e38feddfe7f59d0"
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
