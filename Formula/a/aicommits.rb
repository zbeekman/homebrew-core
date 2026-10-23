class Aicommits < Formula
  desc "Writes your git commit messages for you with AI"
  homepage "https://github.com/Nutlope/aicommits"
  url "https://registry.npmjs.org/aicommits/-/aicommits-4.2.3.tgz"
  sha256 "a1d71b26126c2cb1219b4e8f129345e1dad80e73602c128ae28812c7f6a358bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d74186c66f6dc810e74c4ece8d260b0ec7c61c479d1218ac1864cdaeb19cbdb6"
  end

  depends_on "node"

  deny_network_access! [:postinstall, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "The current directory must be a Git repository!", shell_output("#{bin}/aicommits 2>&1", 1)

    system "git", "init"
    assert_match "No staged changes found. Stage your changes manually, or automatically stage all changes with the",
      shell_output("#{bin}/aicommits 2>&1", 1)
    touch "test.txt"
    system "git", "add", "test.txt"
    assert_match "No configuration found.", shell_output("#{bin}/aicommits 2>&1", 1)
  end
end
