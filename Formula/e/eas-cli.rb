class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-25.0.0.tgz"
  sha256 "f9b92df7d3077c923e6d88d243daaad6690c7fa2dddf0befa8f884d3bdefae90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6c26dd783612367667c1a68c5d78be8744b1cf44aebf640527b63ba49a319f5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")
    assert_match "Run this command inside a project directory",
                 shell_output("#{bin}/eas diagnostics 2>&1", 1)
  end
end
