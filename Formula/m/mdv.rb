class Mdv < Formula
  include Language::Python::Virtualenv

  desc "Styled terminal markdown viewer"
  homepage "https://github.com/axiros/terminal_markdown_viewer"
  url "https://files.pythonhosted.org/packages/d0/32/f5e1b8c70dc40b02604fbd0be3ff0bd5e01ee99c9fddf8f423b10d07cd31/mdv-1.7.5.tar.gz"
  sha256 "eb84ed52a2b68d2e083e007cb485d14fac1deb755fd8f35011eff8f2889df6e9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "b567374f25f0267b6d9cc6fa3b9213ab7d73852cceff20b4e34ced2e49cefd96"
    sha256 cellar: :any,                 arm64_tahoe:       "7e3f993dff2c2285c95d307052eb788af49064b39416a4af601f1b6c8ccff2ed"
    sha256 cellar: :any,                 arm64_sequoia:     "2b2066297ec9e9fe3a49ebab06160e6a8c40b13e70ae5c2afe1e67a2066923b9"
    sha256 cellar: :any,                 arm64_sonoma:      "4948a815dfb995aafe81414e4c8ff8cedf80654574d8521bb71c2aff69e9955c"
    sha256 cellar: :any,                 sonoma:            "182702c80f2feeb950166ccff5f33825d02207948503d3a540c808836b749cd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bcae45fe0cd6e612aa92fce775f120a8414c2937005f0d1821712abd29f1820e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6db5f55e163a5bcdfcc3e2cb15ac45717470850c7c980145ba9fc5e0ff54813e"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages package_name: "mdv[yaml]"

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/f8/4f/700155c8c20d9e655dd0732b5fc3c7614f291b9148da271d7388e50bf774/markdown-3.11.tar.gz"
    sha256 "180224db6aed87ba9ce1f2781ebcd5826253de8ff637112090e24b84502bbf9f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      # Header 1
      ## Header 2
      ### Header 3
    MARKDOWN
    system bin/"mdv", testpath/"test.md"
  end
end
