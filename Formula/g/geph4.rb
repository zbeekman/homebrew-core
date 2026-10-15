class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.99.32.tar.gz"
  sha256 "fd6585717448b796d90b7b6dadd609c86c806ee7b4c9f0a21e27ffb47e8ff59c"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d249ab5a3eabcdc6a18a4fa4fe91bff36aba127085c65b4114ae4362d8bed3fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc9feafe9c20d28772706c2fabdcf31a2bb9516b01ed39a780978d7c89a0335f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12003483d66014286b643b460da29669a749fcd7dbe4e1725ccf3aca9d66ae8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "3aaf50eb8d06e7a2b8baea74bb6e93f1191daf10fbfbc99fa97bee176327f244"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "340080a0bcac0f94e3171c059c5de370822c9d2880ff0b67d315aeaf72234d67"
    sha256 cellar: :any_skip_relocation, sonoma:            "f1f9f47bcdd806687fbe6797689ac67e23d3519325c96322022ce1e6a80360c7"
    sha256 cellar: :any_skip_relocation, ventura:           "a64f9f02478d079fa19a0a66efb0860bc15233d59ecc2b4d266fdd32188225d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ddfe22bccde62ad86f06c9060a8c3c2897fbc0f49e455d69c1aa808e917bae46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bde6c9148a586e0bf317a3991e2567231fcf15be78b1caa2ef340ff0f399c494"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "sqlite" # needs sqlite3_load_extension

  on_linux do
    depends_on "openssl@4"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    rm_r(buildpath/".cargo")
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db auth-password --username x 2>&1", 1)
    assert_match "incorrect credentials", output

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 2144927..0a20b5f 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -4434,9 +4434,9 @@ checksum = "c08d65885ee38876c4f86fa503fb49d7b507c2b62552df7c70b2fce627e06381"
 
 [[package]]
 name = "openssl"
-version = "0.10.70"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "61cfb4e166a8bb8c9b55c500bc2308550148ece889be90f609377e58140f42c6"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.8.0",
  "cfg-if 1.0.0",
@@ -4475,9 +4475,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.105"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8b22d5b84be05a8d6947c7cb71f7c849aa0f112acd4bf51c2a7c1c988ac0a9dc"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
