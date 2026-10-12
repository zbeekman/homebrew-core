class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.65.tgz"
  sha256 "5c59363db7f4bebde95ce6b4d099bfa68c6f22017e39d9d375bd6707b10ef37d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1cf6ce6fcdc495208a6dc384c5d0f2fe6b73be0d8c5be6d1b0ba3450a805210"
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
