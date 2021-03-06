class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://github.com/translate/translate/archive/2.4.0.tar.gz"
  sha256 "7f1d6a9566bb512fd88d51bd8bc920f42e379c91a4686761dbe89762f8a3a51d"
  revision 1
  head "https://github.com/translate/translate.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "83dbc6c6d4aedac2d2b08062e3d200c8d9f19d9e26097f4134b93cd6382c56f2" => :catalina
    sha256 "442d94824f1b8dd243e92cb8843c6cc3a636ea8cc63ddfcdc160a08792c6d9cb" => :mojave
    sha256 "a3d5b1ecbeb2bf56b8356aff63fc16276a5dcf0bffb500cdf1f775f272e05b89" => :high_sierra
  end

  depends_on "python@3.8"

  resource "argparse" do
    url "https://files.pythonhosted.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "diff-match-patch" do
    url "https://files.pythonhosted.org/packages/f0/2a/5ba07def0e9107d935aba62cf632afbd0f7c723a98af47ccbcab753d2452/diff-match-patch-20181111.tar.gz"
    sha256 "a809a996d0f09b9bbd59e9bbd0b71eed8c807922512910e05cbd3f9480712ddb"
  end

  resource "Python-Levenshtein" do
    url "https://files.pythonhosted.org/packages/42/a9/d1785c85ebf9b7dfacd08938dd028209c34a0ea3b1bcdb895208bd40a67d/python-Levenshtein-0.12.0.tar.gz"
    sha256 "033a11de5e3d19ea25c9302d11224e1a1898fe5abd23c61c7c360c25195e3eb1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
  end
end
