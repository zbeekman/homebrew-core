class Codeburn < Formula
  desc "See where your AI coding tokens go - by task, tool, model, and project"
  homepage "https://codeburn.app/"
  url "https://registry.npmjs.org/codeburn/-/codeburn-0.9.27.tgz"
  sha256 "03e90a178821865af474a5511a985de1c53e63799ffafa34e76f0d8dd58911f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "61e6dd784c153e98770dcc85043b67a5f73f11d63677d59778b957515289d491"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61e6dd784c153e98770dcc85043b67a5f73f11d63677d59778b957515289d491"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "61e6dd784c153e98770dcc85043b67a5f73f11d63677d59778b957515289d491"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6ba6d4ba7999e2424a52dd27e63c5c3db2bd19b58bf79424c46817cf459eaf3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6ba6d4ba7999e2424a52dd27e63c5c3db2bd19b58bf79424c46817cf459eaf3f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/codeburn report --period today --format json")
    assert_match "\"generated\"", output
    assert_match "\"period\":", output
    assert_match "\"overview\"", output
  end
end
