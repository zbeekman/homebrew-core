class Chardet < Formula
  include Language::Python::Virtualenv

  desc "Python character encoding detector"
  homepage "https://chardet.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/47/92/3d893ac5d338b9a9af34c5b517d77492dcea8a10254254eead4215a96f3f/chardet-7.7.0.tar.gz"
  sha256 "0ba38a05201b0abf7570c12d8af45c30b2af835bd5cc52bfc7105082eda82c1e"
  license "0BSD"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "eb5da8cd1c212d3784072bd05c2b737637e69c804b511ee6ca0e3bc28ac7bcdb"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write "你好"
    output = shell_output("#{bin}/chardetect #{testpath}/test.txt")
    assert_match "test.txt: utf-8 with confidence", output
  end
end
