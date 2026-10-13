class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.155.5.tgz"
  sha256 "fbf3812bc3b20591aa018229199c89762e4ed37c4c9e5be24a3bcc0791b1b1da"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "b637ac72257d2a9a82a8dadc1910dbd8c4737a84010a744400a0fe693c2e841c"
    sha256 cellar: :any,                 arm64_tahoe:       "b637ac72257d2a9a82a8dadc1910dbd8c4737a84010a744400a0fe693c2e841c"
    sha256 cellar: :any,                 arm64_sequoia:     "b637ac72257d2a9a82a8dadc1910dbd8c4737a84010a744400a0fe693c2e841c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4fdb02c3c4ae31554246c6f3650ed05a8d8a0b3d4d636c756722eaebb9bd28f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c16cb08e10150024b51958492c7e9e7502d80cb8a3f9862595932712384d72db"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
