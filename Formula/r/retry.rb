class Retry < Formula
  desc "Repeat a command until the command succeeds"
  homepage "https://github.com/minfrin/retry"
  url "https://github.com/minfrin/retry/releases/download/retry-1.0.7/retry-1.0.7.tar.bz2"
  sha256 "eb96b60244e09f407db9eb32cb9ad52361aaef4d19ca84817a6f88f577b60d6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7674074b66a5fca43ae2f063df497ac8dcfe4308819f402e6b4b264068c747b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77c76b42cc0cf87c1df0336f794ed29b0daf828d3c43dc2465df8936260f2040"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b67d9e7e3b419a6369f651a9eea7c56342004e9aecfea372c8551fd024a45b97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "91d9191c2224348d123ab4b8e5763ec2337c4846f3d8d391aba99bbe3a6c9898"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "e7ef82f7765062f44a5ff5b4ba8bee756c3e55d380bc0b0b99622f78b7740ce3"
    sha256 cellar: :any_skip_relocation, sonoma:            "3c3f927459a0efd10619ecf2b412a1380c148dcc796e9f9e7e174eb0499fdc12"
    sha256 cellar: :any_skip_relocation, ventura:           "7f24158fe4cccb03dca7bc286df3744f4fbabf78cf2af266d3269a31e06466a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0e11ae4779ffb1e810dea7f628d0820ed8ee798b268441bdcc3f12baee7deec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "259bb647677bf0520f8341216056f6e6f1be2cddacc822b729932f38f9449d74"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"retry.sh").write <<~SH
      attempt=0
      if [ -f attempts ]; then
        read -r attempt < attempts
      fi
      attempt=$((attempt + 1))
      echo "$attempt" > attempts
      [ "$attempt" -eq 3 ] || exit 1
      echo success
    SH

    assert_equal "success\n", shell_output("#{bin}/retry --quiet --delay 0 --times 3 -- sh retry.sh")
    assert_equal "3\n", (testpath/"attempts").read

    (testpath/"attempts").unlink
    shell_output("#{bin}/retry --quiet --delay 0 --times 2 -- sh retry.sh", 1)
    assert_equal "2\n", (testpath/"attempts").read
  end
end
