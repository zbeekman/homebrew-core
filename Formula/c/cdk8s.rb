class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.67.tgz"
  sha256 "83559418a26ceb7ee7cf4d8983f7b1e7d485084aea68e2af08191f3ec42b1dc9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a7ff1550ccc654cfa40b03cf0efeaef84a5c37ef4752a0af23a395c0fc900e0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
