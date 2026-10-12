class Asitop < Formula
  include Language::Python::Virtualenv

  desc "Perf monitoring CLI tool for Apple Silicon"
  homepage "https://tlkh.github.io/asitop/"
  url "https://files.pythonhosted.org/packages/93/bc/8755d818efc33dd758322086a23f08bee5e1f7769c339a8be5c142adbbbc/asitop-0.0.24.tar.gz"
  sha256 "5df7b59304572a948f71cf94b87adc613869a8a87a933595b1b3e26bf42c3e37"
  license "MIT"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97758bc6f17e81cb9d702f6b60ae3e7f734555ffbf9f432d9ef8afddf4ca4676"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de255de46d14df3c89b457ed3e18d402a63a6a24b47da228084646a20e6b9db0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a40878e9b51a199368c3647e227773c8a8fa2413f64167630cb05e92fe3b4bb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "73ede524bcc50e849a3568afe14f6a2469e5a439f79dd284b21cc0a4b1f41ab5"
  end

  depends_on arch: :arm64
  depends_on :macos
  depends_on "python@3.15"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/0c/7d/44d82d953d9bbcac57fe26507ea7ffba65ef1ec8f41f2b58da2fb12ef26c/blessed-1.50.0.tar.gz"
    sha256 "046c9b2a5283a9c5bc340ed23b7d1c1f10ef2d7fb30b14bae13ef7ffc1f3ba56"
  end

  resource "dashing" do
    url "https://files.pythonhosted.org/packages/bd/01/1c966934ab5ebe5a8fa3012c5de32bfa86916dba0428bdc6cdfe9489f768/dashing-0.1.0.tar.gz"
    sha256 "2514608e0f29a775dbd1b1111561219ce83d53cfa4baa2fe4101fab84fd56f1b"
  end

  resource "jinxed" do
    url "https://files.pythonhosted.org/packages/39/d7/6e6d474ec5eaeca6a61acc17766bb19563b3a372b4b9d92910078f5fe49f/jinxed-2.1.0.tar.gz"
    sha256 "7e755b831faa2443d44fb4ce7c0202eb9c3ed39bd5bf1193365888f4f6092b54"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources
    bin.env_script_all_files(libexec, PYTHONDONTWRITEBYTECODE: "1")
  end

  test do
    output = shell_output("#{bin}/asitop 2>&1", 1)
    # needs sudo permission to run
    assert_match "You are recommended to run ASITOP with `sudo asitop`", output
    assert_match "Performance monitoring CLI tool", shell_output("#{bin}/asitop --help")
  end
end
