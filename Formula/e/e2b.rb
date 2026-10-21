class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.22.2.tgz"
  sha256 "59c63cce30c18694ba8266505d2b1a4249deb0b99ff4c6b34a072e38c851beb7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ee8bfd2cc100ccde3967b5945767245065982fee591f69cae13617ddaf7cfc8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
