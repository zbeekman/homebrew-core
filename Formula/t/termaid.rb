class Termaid < Formula
  include Language::Python::Virtualenv

  desc "Render Mermaid diagrams in the terminal"
  homepage "https://github.com/fasouto/termaid"
  url "https://files.pythonhosted.org/packages/6c/5c/e2bc0d27c30de7a55a1c7fac8326454353058385864c5cda4a0d9d19ec59/termaid-0.9.1.tar.gz"
  sha256 "e81ccdf92590182873b5a6437d709264fd70611a91f130f14418e80fad4c7ecf"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b0c0e746bc7cf02eeba068dbeaccdabbfe7c85e66d97976e9f15c6aff1543a1b"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output(bin/"termaid", "graph LR\n  A[Start] --> B[End]\n")
    assert_match "Start", output
    assert_match "End", output
    assert_match version.to_s, shell_output("#{bin}/termaid --version")
  end
end
