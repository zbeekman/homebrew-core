class Cutadapt < Formula
  include Language::Python::Virtualenv

  desc "Removes adapter sequences from sequencing reads"
  homepage "https://cutadapt.readthedocs.io"
  url "https://github.com/marcelm/cutadapt.git",
      tag:      "v5.2",
      revision: "ef852629f667637439f28761499bb56126e390a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8ee488551f318879bb76421fa0ac63d0d239e55c96058183ba4ccefe05eab65a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b7435a5334637e1cac9fc9682aae40a0807cb52ecc8559d4cd7f127b74e185c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6191683861ae3b20d47010fe1a76def344285fd0e53878ae76949a8b131346af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "cce57d4c939e86b80f702243984b4c74b6830c4e1d7b760255820ad1c225b6b1"
    sha256 cellar: :any_skip_relocation, sonoma:            "a4d1fcf14494014bacfd1a6791252e6476762a071ac8332daa24dc875b61e3a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5e6931901df9dc23b3858f38d1a0794052062f4e91d78cdef245ee2daac594a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "65d6ebdce3764e07bb923ed83763443dd031c48e7eed780a4d683069361e0ef5"
  end

  depends_on "python@3.15"

  on_intel do
    depends_on "nasm" => :build
  end

  resource "dnaio" do
    url "https://files.pythonhosted.org/packages/a9/f2/3b4d7f4ac4fc25742fde4c5b50ed1bc60ab731cf8cabd3089dd11e4ea1c9/dnaio-1.2.4.tar.gz"
    sha256 "a7570311f29e8b3c1ea39a60f57b7baf8dad8f2508595c58d4278c5571463166"
  end

  resource "xopen" do
    url "https://files.pythonhosted.org/packages/77/bb/74a5222fc975fccb9f8bfb62613ca42a5a28008362c598df09806ecd12c1/xopen-2.1.0.tar.gz"
    sha256 "06584821588f813563863b63d5e02568a4328661b7507ea38c432f24c69ea4b7"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "tests/data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cutadapt --version")

    system bin/"cutadapt", "-a", "AACCGGTT", "-o", "output.fastq", pkgshare/"data/small.fastq.gz"
    assert_path_exists "output.fastq"
  end
end
