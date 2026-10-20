class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://files.pythonhosted.org/packages/3f/e2/ec751ab6385d29be7a8d7a54379fa7d3267440c55dde0f265a0730417027/vermin-1.9.2.tar.gz"
  sha256 "ba4e01ab817c6baadf5f057bd6ea691e1147bcaf00c1ac8db54df0e25c6d2c6d"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e32a03d00da88798f31a5ddeebebc5dea1686cee014990f47fe4f1f87a4a92b"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/vermin --no-parse-comments #{bin}/vermin")
      Minimum required versions: ~2, ~3
      Note: Not enough evidence to conclude it won't work with Python 2 or 3.
    EOS

    assert_match version.to_s, shell_output("#{bin}/vermin --version")
  end
end
