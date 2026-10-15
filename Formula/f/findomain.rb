class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/refs/tags/10.0.1.tar.gz"
  sha256 "2562943c29a9b3ce1b76685d9e7de1ad5109f80a35c6941e7853b31fb92641fa"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9064a3e8756c900ad3cb2585b7a75012c2619d483e0ab8d712613c2a145b25c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2902d22ca4f66ec6f1549cc6a391cc9b11eec6c00256a443b1298e8c22190b9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "37c97dddda6da60c11c406b3e89b858ba97a82fd70bab6ec965b19ab5ba1f40f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e134ae5781d721d8f18a661fbfc6449e4a64f424d7cfa2b739eecd5c9a15d9c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "6720db936685348595235d6645e8fa2a785673d76655252f2b8a02808e3622dc"
    sha256 cellar: :any_skip_relocation, sonoma:            "dcb0ada61e17bafa0698afe7fd63d3a00d3f3eca2611bf1e31f48624f315f798"
    sha256 cellar: :any_skip_relocation, ventura:           "621fa5b8468b1bcd55a6e7300653cbd8eb120e697374a3f3e00aeb5c414fae3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a1b59bf4dc0ed116bf7c1ec94a706f0e48ba2c7523eff3abd77d421d5a54f0ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d66e42b9aab95ae691640efaeb89d232491d144010b208285fb73b986a0c4a6a"
  end

  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index c2ad9a5..30d1de8 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1885,15 +1885,14 @@ checksum = "a4895175b425cb1f87721b59f0f286c2092bd4af812243672510e1ac53e2e0ad"
 
 [[package]]
 name = "openssl"
-version = "0.10.73"
+version = "0.10.81"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8505734d46c8ab1e19a1dce3aef597ad87dcb4c37e7188231769bd6bd51cebf8"
+checksum = "77823a27f0babb03091cb9ed9ef80af3b39dbc82f97e8fa530374b7dafd87a45"
 dependencies = [
  "bitflags 2.9.1",
  "cfg-if",
  "foreign-types",
  "libc",
- "once_cell",
  "openssl-macros",
  "openssl-sys",
 ]
@@ -1926,9 +1925,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.109"
+version = "0.9.117"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "90096e2e47630d78b7d1c20952dc621f957103f8bc2c8359ec81290d75238571"
+checksum = "b47e7e6bb2c38cd930d25a23b40fa52e068c10e85f3e03a7f5ba5aaca5713695"
 dependencies = [
  "cc",
  "libc",
