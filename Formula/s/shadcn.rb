class Shadcn < Formula
  desc "CLI for adding components to your project"
  homepage "https://ui.shadcn.com"
  url "https://registry.npmjs.org/shadcn/-/shadcn-4.21.5.tgz"
  sha256 "588f42db012fdd0edee6ddf0c1d79e0b94013188960d6a09c9e0c0e416bd2bab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "67c4d2bdc04848ca1e6e77a8c5c2dd9202753c704b82e32034d908c27aeb78a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67c4d2bdc04848ca1e6e77a8c5c2dd9202753c704b82e32034d908c27aeb78a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67c4d2bdc04848ca1e6e77a8c5c2dd9202753c704b82e32034d908c27aeb78a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "43812fce5d981263ca47d7331a92a681ddafda8c008e777203283ec772a8c5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "43812fce5d981263ca47d7331a92a681ddafda8c008e777203283ec772a8c5d9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shadcn --version")

    pipe_output = pipe_output("#{bin}/shadcn init -d 2>&1", "brew\n")
    assert_match "Project initialization completed.", pipe_output
    assert_path_exists "#{testpath}/brew/components.json"
  end
end
