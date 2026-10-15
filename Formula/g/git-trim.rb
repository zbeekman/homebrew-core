class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim.git",
      tag:      "v0.4.4",
      revision: "1f39d85ddb242e9933fba9faaecd6f423f2b6a5b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_golden_gate: "65ae181195c67fc815496c76a092f08709fe7c10f71c1955c209fb4099ad7b6f"
    sha256 cellar: :any,                 arm64_tahoe:       "c1a667c8d8f57a5a98f74f25c31b4a42c3e1a590a828d3bf15fb12610fa6c502"
    sha256 cellar: :any,                 arm64_sequoia:     "e6da3b71f915437663871a49da0908935c8c5d8f3482a8b03fbd469e3607c7b6"
    sha256 cellar: :any,                 arm64_sonoma:      "5b21797251a5babcb06c7dfdf3ca3e22bf5911969f2432d14f1b133dccf8af8f"
    sha256 cellar: :any,                 sonoma:            "2f46851b510f9951089a9166b0252f9802b0e7274dc493c0a44e296014fd8cee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eb6ad0313b09996c5057fa9d8c14c7ffada62ac91a635cc7eb7407eee01c9d44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "aeeea3f5e9d35984a91e402d8e8c315b1806ab1ebcd5c13832d1a10dbbcdeab1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libssh2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Update to openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # TODO: ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args
    man1.install "docs/git-trim.man" => "git-trim.1"
  end

  test do
    system "git", "clone", "https://github.com/foriequal0/git-trim"
    Dir.chdir("git-trim")
    system "git", "branch", "brew-test"
    assert_match "brew-test", shell_output("git trim")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 6cc4c66..2ed2e87 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1489,11 +1489,10 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.78"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "07d5c8cb6e57b3a3612064d7b18b117912b4ce70955c2504d4b741c9e244b132"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
- "autocfg",
  "cc",
  "libc",
  "pkg-config",
