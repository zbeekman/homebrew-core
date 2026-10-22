class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/iczelia/bzip3"
  url "https://github.com/iczelia/bzip3/releases/download/1.5.5/bzip3-1.5.5.tar.gz"
  sha256 "dc3bd8237178e1a2b99d8dcf1f4aeb3593c723788a9863606e121b40784e596d"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3b053b6ec6f0d95f53821f25515c3a7a5d8dadc04336b9adc3231aa8a0647c00"
    sha256 cellar: :any, arm64_tahoe:       "ed476ab20e78299627bae28bb0dd902bb768d3ece86b25176eac10479d984f47"
    sha256 cellar: :any, arm64_sequoia:     "948798834e5f0dc0ad6d208ff24ed9a2e636392d22159faafe3ecaab82ee526e"
    sha256 cellar: :any, arm64_sonoma:      "6c3d602ca043ec524307b38b43d15865ad28fdefca67b159d46a65835f905171"
    sha256 cellar: :any, arm64_linux:       "e7ae0b8e3d71d7fb83166b7c6982d0d5b52b70082e298c9448171a740103a12b"
    sha256 cellar: :any, x86_64_linux:      "579ecd6e7477d9fa72ae9f3041b9c75f543e546780c1703132de2105dbadcd10"
  end

  depends_on "pkgconf" => :build

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", "--disable-arch-native", *std_configure_args
    system "make", "install"
  end

  test do
    testfilepath = testpath/"sample_in.txt"
    zipfilepath = testpath/"sample_in.txt.bz3"

    testfilepath.write "TEST CONTENT"

    system bin/"bzip3", testfilepath
    system bin/"bunzip3", "-f", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
