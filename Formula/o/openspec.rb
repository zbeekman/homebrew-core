class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.14.3.tgz"
  sha256 "f7a4eaf9199036713edf331f1a781abebc4ed9bd3fbf5a8aa549f482749e14c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d8865583d4c4c5ceff3652ac8b6449ade9091afb2af196e692a97b67712fa1dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8865583d4c4c5ceff3652ac8b6449ade9091afb2af196e692a97b67712fa1dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d8865583d4c4c5ceff3652ac8b6449ade9091afb2af196e692a97b67712fa1dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c9110fc4a8939d03a7b316c08273b769ddd682d88c23a141a5f2280b8e28544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3c9110fc4a8939d03a7b316c08273b769ddd682d88c23a141a5f2280b8e28544"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    generate_completions_from_executable(bin/"openspec", "completion", "generate")
  end

  test do
    system bin/"openspec", "init", "--tools", "none"
    assert_path_exists testpath/"openspec/changes"
    assert_path_exists testpath/"openspec/specs"
  end
end
