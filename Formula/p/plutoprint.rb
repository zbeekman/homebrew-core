class Plutoprint < Formula
  include Language::Python::Virtualenv

  desc "Generate PDFs and Images from HTML"
  homepage "https://github.com/plutoprint/plutoprint"
  url "https://files.pythonhosted.org/packages/6b/e8/7db9d2d4801b80928f3b53d90d7343873aebed06b4cef5b71bc25f77086b/plutoprint-0.23.0.tar.gz"
  sha256 "6240e645599f08953fe0296b5b1955c6a978b212a05b878c2ba652a8ce7a0c82"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "699a02f4f7d8bbeb6f03ff1c736a19728d6942b1d7d7b7851aa1c6c5c894d6d9"
    sha256 cellar: :any, arm64_tahoe:       "953227bc0aad231128224a076e2ede68bd2d8ef750ece55956a12d1e916862c2"
    sha256 cellar: :any, arm64_sequoia:     "66911646d8e77c81f00954287d52825208921af68004e469f19c5526ed8f2bc1"
    sha256 cellar: :any, arm64_linux:       "9906a72cb26535e828732ab8c6dc7a02d357f43a44a0c63e2707309ff24e67cf"
    sha256 cellar: :any, x86_64_linux:      "7e79826908adcf181a2d306a8eef8128062a44c7287eb6143e4b6ab58c7a43d8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "plutobook"
  depends_on "python@3.15"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plutoprint --version")

    (testpath/"test.html").write <<~HTML
      <h1>Hello World!</h1>
    HTML

    system bin/"plutoprint", "test.html", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
