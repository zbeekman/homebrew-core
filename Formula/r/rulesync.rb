class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-35.0.0.tgz"
  sha256 "104f9b9b1daa5a1d53c2261cbb8c66e20f5b831157e6a5b7802080ae3b7b20e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d427e5475655ec0e2d0df06fe9602ff0f763fa7629d6f57605cf8b4415b62ee1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d427e5475655ec0e2d0df06fe9602ff0f763fa7629d6f57605cf8b4415b62ee1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d427e5475655ec0e2d0df06fe9602ff0f763fa7629d6f57605cf8b4415b62ee1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a9d9338b3a57cfd78e09fea774aebd2b13ee9d9be853667a74a14d3fa342a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3a9d9338b3a57cfd78e09fea774aebd2b13ee9d9be853667a74a14d3fa342a48"
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
