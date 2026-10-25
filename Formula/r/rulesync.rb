class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-41.0.0.tgz"
  sha256 "a3db2475176e4b314574b0b3f786a0976ec109b459c9ffc2ddaab4b3197d5a30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49b6a303fcfa51204b2bc606f75fa942dd352cc46ce9a8eb67fb476033831a41"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49b6a303fcfa51204b2bc606f75fa942dd352cc46ce9a8eb67fb476033831a41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49b6a303fcfa51204b2bc606f75fa942dd352cc46ce9a8eb67fb476033831a41"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d0ac19c6546bb568f21642c21ed82968a16527246939669c8f4eca44452d5981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d0ac19c6546bb568f21642c21ed82968a16527246939669c8f4eca44452d5981"
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
