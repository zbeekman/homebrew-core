class Pyspelling < Formula
  include Language::Python::Virtualenv

  desc "Spell checker automation tool"
  homepage "https://facelessuser.github.io/pyspelling/"
  url "https://files.pythonhosted.org/packages/fe/ed/3fe00b8a3f8a74a993e1e08931d674cde7bd718c1af44ef415ff1f6b000b/pyspelling-2.12.1.tar.gz"
  sha256 "9108981dc174d6400a7ed4917cf4af91daf3eb83578d4570c0726b92c2a32e7a"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a174a1d067b3b4eea7ceeb70836c230ba9146a85d0675062b1a4a864acf13696"
    sha256 cellar: :any, arm64_tahoe:       "53ef517e0c3a54ce3b3e0f74f9b81838f6fec74aac2d84fce7054b71ed9d4211"
    sha256 cellar: :any, arm64_sequoia:     "ddfa190d29c754cbe0eae7a38152585a82c180269fb7e97f5b6463fb22ab8d05"
    sha256 cellar: :any, arm64_linux:       "20e14770e3c8f61e9e1751386af491590e166a55dd2089e7f984e6a727307aa4"
    sha256 cellar: :any, x86_64_linux:      "b1b09834642fca3b35dca5789a48a20cb7a6435b6d55704888e9902fa85e1e79"
  end

  depends_on "aspell" => :test
  depends_on "libyaml"
  depends_on "python@3.15"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/e1/60/e2a6409041cb3f8ce7ac3d6917b5b30c39f81a0a5b2d414ec30f36fd96bf/bracex-3.1.tar.gz"
    sha256 "35c69fc105f08d77c02722e8ae707c656ff298dd4d26c89bcb3c98fca8bc3614"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"

    # Fix to build with Python 3.14
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/b90dafff1bf342d34d539098013d0b9f318c7641.patch?full_index=1"
      sha256 "779f8bab52308792b7ac2f01c3cd61335587640f98812c88cb074dce9fe8162d"
      type :unofficial
      resolves "https://github.com/html5lib/html5lib-python/pull/589"
    end
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/f8/4f/700155c8c20d9e655dd0732b5fc3c7614f291b9148da271d7388e50bf774/markdown-3.11.tar.gz"
    sha256 "180224db6aed87ba9ce1f2781ebcd5826253de8ff637112090e24b84502bbf9f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/71/c3/1b817965ac12dc002d7c9cd7dfffdd7d4fbf9b45763ef2ffe7b86ee94670/soupsieve-2.10.tar.gz"
    sha256 "49e9380d7d2905463583bafe285e818c7366a9ed7b3aee221c1ac79c905d8bc0"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/78/cd/0e028d8b7d906d51acdac537334fbe85f8284f2a8147d48bc9403af77a0d/wcmatch-11.1.tar.gz"
    sha256 "f2b6f0fad6f5e2571498723fcb3c8facdd0fba0dcc139f31d32f592eb648153e"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/d5/a0/8fd707bcb776a7be556bad06a2ea5fb9bd519df78ef8e26f70ccf0f38bff/webencodings-0.6.1.tar.gz"
    sha256 "565f9ad031c702dae404e27a099e3e09186a3ab1b9520f06d215502b651fd910"
  end

  def install
    # Workaround for https://github.com/html5lib/html5lib-python/issues/593
    odie "Check if setuptools workaround can be removed!" if resource("html5lib").version > "1.1.0"
    (buildpath/"build-constraints.txt").write "setuptools<82\n"
    ENV["PIP_BUILD_CONSTRAINT"] = buildpath/"build-constraints.txt"

    virtualenv_install_with_resources
  end

  test do
    (testpath / "text.txt").write("Homebrew is my favourite package manager!")
    (testpath / "en-custom.txt").write("homebrew")
    (testpath / ".pyspelling.yml").write <<~YAML
      spellchecker: aspell
      matrix:
      - name: Python Source
        aspell:
          lang: en
          d: en_US
        dictionary:
          wordlists:
          - #{testpath}/en-custom.txt
        sources:
        - text.txt
    YAML

    output = shell_output(bin/"pyspelling", 1)
    assert_match <<~EOS, output
      Misspelled words:
      <text> text.txt
      --------------------------------------------------------------------------------
      favourite
      --------------------------------------------------------------------------------
    EOS
  end
end
