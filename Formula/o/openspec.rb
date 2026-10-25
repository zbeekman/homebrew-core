class Openspec < Formula
  desc "Spec-driven development (SDD) for AI coding assistants"
  homepage "https://openspec.dev/"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.15.0.tgz"
  sha256 "5c2274b7f5b2e52ebe8dc6c4d616837d0326a8c83eb7d3ca181539dedbf02644"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ebc294b29baafe1564f6e56706faf07d713e2d80ddcfc8af5a24628dfda33b70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ebc294b29baafe1564f6e56706faf07d713e2d80ddcfc8af5a24628dfda33b70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ebc294b29baafe1564f6e56706faf07d713e2d80ddcfc8af5a24628dfda33b70"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e1cc58942d8f096f06d6323657365fb52079ea2a94ab345a3fc32e466ae37363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e1cc58942d8f096f06d6323657365fb52079ea2a94ab345a3fc32e466ae37363"
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
