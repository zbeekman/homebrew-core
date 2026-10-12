class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-32.0.0.tgz"
  sha256 "f08fbddbe7b91e1193ff92cf28e6072e794bda841e9e11ebef3d9fee56df503a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "759e5697049dbb0f38076d76199a242a28a5922f8bd6af5eaf8c83de00da828c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "759e5697049dbb0f38076d76199a242a28a5922f8bd6af5eaf8c83de00da828c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "759e5697049dbb0f38076d76199a242a28a5922f8bd6af5eaf8c83de00da828c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a90423435c2c0f493d73aadf9aca489295f7c4ddb423d5497cae55dccac8b4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a90423435c2c0f493d73aadf9aca489295f7c4ddb423d5497cae55dccac8b4c2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
