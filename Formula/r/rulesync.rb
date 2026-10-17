class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-36.0.1.tgz"
  sha256 "ae6c76625d356085e48934af5eed8de87aa7eb71b237d45c6b52184461084163"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d06fcdc7fcd267122d5f92c5f19f4435508787f9272805d3ea6778ea2812ec0e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d06fcdc7fcd267122d5f92c5f19f4435508787f9272805d3ea6778ea2812ec0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d06fcdc7fcd267122d5f92c5f19f4435508787f9272805d3ea6778ea2812ec0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3803d01eb3612a5ccf4e3728a1e4d87e077d10f60cfdda642a72172c664ed288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3803d01eb3612a5ccf4e3728a1e4d87e077d10f60cfdda642a72172c664ed288"
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
