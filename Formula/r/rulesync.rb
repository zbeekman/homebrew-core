class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-40.1.0.tgz"
  sha256 "9e46d8f4289c26b4d784bc84958c0efe633300b8690b779822e450caa761b61e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f33d0c229b416a767a9bdbd9dc577a42c4cd89d27f71fad3cb68530ae90a55f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f33d0c229b416a767a9bdbd9dc577a42c4cd89d27f71fad3cb68530ae90a55f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f33d0c229b416a767a9bdbd9dc577a42c4cd89d27f71fad3cb68530ae90a55f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "93992cd1633475d8af4f1dcafef787cc7429c856c762e752ea2b4c9f3a933e39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "93992cd1633475d8af4f1dcafef787cc7429c856c762e752ea2b4c9f3a933e39"
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
