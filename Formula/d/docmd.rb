class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.io"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.9.8.tgz"
  sha256 "4ad5df3a34db50812f88d4cf68dabe5d1cb57bd3149bb84f9aee8a1cc082e1dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ccbaaeec8141be740e1fcf9b1c1ec961a8c1c65830d529ac43897f49ac5dcf40"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@docmd/core/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.json"
    assert_match 'title: "Quick Start"', (testpath/"docs/index.md").read
  end
end
