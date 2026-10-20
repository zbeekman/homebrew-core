class VaultCli < Formula
  desc "Subversion-like utility to work with Jackrabbit FileVault"
  homepage "https://jackrabbit.apache.org/filevault/index.html"
  url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/4.3.0/vault-cli-4.3.0-bin.tar.gz"
  sha256 "86aabecc10c28b8df19e842f8a3133ceb724e39682898e14cd3094007f99c942"
  license "Apache-2.0"
  head "https://github.com/apache/jackrabbit-filevault.git", branch: "master"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/jackrabbit/vault/vault-cli/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a477aac9d9b50e2c9b32b75e71e3bb5f28238d49e39354608d62b49462eb954d"
  end

  depends_on "openjdk"

  def install
    # Remove windows files
    rm(Dir["bin/*.bat"])

    libexec.install Dir["*"]
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: formula_opt_prefix("openjdk"))
  end

  test do
    # Bad test, but we're limited without a Jackrabbit repo to speak to...
    system bin/"vlt", "--version"
  end
end
