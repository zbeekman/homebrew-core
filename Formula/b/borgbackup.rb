class Borgbackup < Formula
  include Language::Python::Virtualenv

  desc "Deduplicating archiver with compression and authenticated encryption"
  homepage "https://www.borgbackup.org/"
  url "https://files.pythonhosted.org/packages/62/5b/aec6c069840f64f744d661c5eea1c648d407bebb836b2e12d8a3b9939bb4/borgbackup-1.4.5.tar.gz"
  sha256 "4f9a5fe584c504b15485841236750dea16aa7cd2ddbc4a594e9d2ce5c49c4508"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/borgbackup/borg.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7beafc264e9eecdc9796b4315e38d6cf7018583114f522dcb9f263f11bb09141"
    sha256 cellar: :any, arm64_tahoe:       "87f345d494116ec16325d95a2b6476f950217de3c2bab918efda40edd79a22cf"
    sha256 cellar: :any, arm64_sequoia:     "6e99e7ecc16203dd41cafa0d158d816954c1312d39d68e9afc25e0f4e0b492be"
    sha256 cellar: :any, arm64_linux:       "9a1be4acf86f6cd5d6db6031e58588337a2f362b0ddfe1f1f46e2046f7470a32"
    sha256 cellar: :any, x86_64_linux:      "e7eb1b80871b9a629af3c4f0ad44466f27003fccc68e204953ef6a61d4d40fe8"
  end

  depends_on "pkgconf" => :build
  depends_on "libb2"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "python@3.15"
  depends_on "xxhash"
  depends_on "zstd"

  on_linux do
    depends_on "acl"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/31/f9/c0a1c127f9049db9155afc316952ea571720dd01833ff5e4d7e8e6352dbb/msgpack-1.2.1.tar.gz"
    sha256 "04c721c2c7448767e9e3f2520a475663d8ee0f09c31890f6d2bd70fd636a9647"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  def install
    ENV["BORG_LIBB2_PREFIX"] = formula_opt_prefix("libb2")
    ENV["BORG_LIBLZ4_PREFIX"] = formula_opt_prefix("lz4")
    ENV["BORG_LIBXXHASH_PREFIX"] = formula_opt_prefix("xxhash")
    ENV["BORG_LIBZSTD_PREFIX"] = formula_opt_prefix("zstd")
    ENV["BORG_OPENSSL_PREFIX"] = formula_opt_prefix("openssl@4")

    # Parallel cythonize needs POSIX semaphores, which the Linux build sandbox denies
    inreplace "setup.py", /^cpu_threads = .*/, "cpu_threads = None"

    virtualenv_install_with_resources

    man1.install Dir["docs/man/*.1"]
    bash_completion.install "scripts/shell_completions/bash/borg"
    fish_completion.install "scripts/shell_completions/fish/borg.fish"
    zsh_completion.install "scripts/shell_completions/zsh/_borg"
  end

  test do
    # Create a repo and archive, then test extraction.
    cp test_fixtures("test.pdf"), testpath

    system bin/"borg", "init", "-e", "none", "test-repo"
    system bin/"borg", "create", "--compression", "zstd", "test-repo::test-archive", "test.pdf"
    mkdir testpath/"restore" do
      system bin/"borg", "extract", testpath/"test-repo::test-archive"
    end

    assert_path_exists testpath/"restore/test.pdf"
    assert_equal File.size(testpath/"restore/test.pdf"), File.size(testpath/"test.pdf")
  end
end
