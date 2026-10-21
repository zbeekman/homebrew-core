class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-25.3.0.tgz"
  sha256 "198dbcb08096ade15998b9a34a28479f86088e1fcfd89e9d213bdabac4966133"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "373a5d8dc93053beeb511158cdf01cda740eafb7b04bb56efb5bfb46f2c74ac8"
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
