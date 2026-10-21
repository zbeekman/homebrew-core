class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.15.2.tgz"
  sha256 "364a418993680ee0385baafe807f4f74ce72a4d6165dfe96c2d39dd08a8d74ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88cc89efdf00be8f47c14a975c62f4a5799b3a8aac1ef2a9eae88ad7b1b104ee"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "Using transport strategy: http-first",
      shell_output("#{bin}/mcp-remote https://mcp.example.com/mcp 2>&1", 1)
  end
end
