class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.8.2.tgz"
  sha256 "f40403fc216b3ee77161e5e0487a6fb7f54c1ffc93d6e0cf22e4b206f592fc64"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "d386c967f0e38f437086bb0b03a8eeac69516f4bb2f471e53e04585714208e26"
    sha256 cellar: :any,                 arm64_tahoe:       "60738222814804c43a0a3331d69615b2d01105bbd169bc1e0c729be72d4716a9"
    sha256 cellar: :any,                 arm64_sequoia:     "f5930ad2a456251b7b1e8c29403e2d05ad13f397cfca338a49c453d27af10741"
    sha256 cellar: :any,                 arm64_sonoma:      "f5930ad2a456251b7b1e8c29403e2d05ad13f397cfca338a49c453d27af10741"
    sha256 cellar: :any,                 sonoma:            "80cb4ca3fefd204c3cec450725dacce894ee17356bfe7af930c35a8237709e9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9f3bb2af1fd0dc7efc12c69d52f5ed4dec8ae9fb3e835f556b543f9e703976c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "80102f13fe2ed38139d2a6f557851ab3d30f94886ea2e34e09d05335754c68f2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end
