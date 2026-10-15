class Kty < Formula
  desc "Terminal for Kubernetes"
  homepage "https://kty.dev"
  url "https://github.com/grampelberg/kty/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "050c8b0df88f65e1a06863bea99495b77bf2045829825e7e130756f1828c6aa6"
  license "Apache-2.0"
  head "https://github.com/grampelberg/kty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76c1cde1598e0913741158e01e340c9d910605eb858b611f90e2733eb270db14"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41ffc85a1afa73590d563262abbe3c3037cd0ea6ce1b2a4e315b789de481c709"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb4ba6e5d3a1002a498075b31b9ffc694425ba048333ecf2ee662db7f08d1d64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "4a01a6547caa11fd487eb9470ed8552bd699731eb3011eabc38c4ce1fe9bc07d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "773957f43cf0e1a552700e177d52a0c4dc9a16738e6d33fad6fc1b3981f33e0f"
    sha256 cellar: :any_skip_relocation, sonoma:            "d5dbd72cf1840b254b2ac815e8dad173883c8cb83140634976e29a14fcf8b65d"
    sha256 cellar: :any_skip_relocation, ventura:           "844450842762cb450a2885857744a5ea3a095d781db143312f3ff4607ec7b890"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "12eaaeecb6106661c66894aca09a5f73eb77d9be2ba51419f1d78eed9872aed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bdd2bbe08fcd0a77a2402d91f009d13d4c9ddd5b51d533d4810e26aee40fccb9"
  end

  # Last release on 2024-09-16, last activity 2024-10-03
  deprecate! date: "2026-10-15", because: :unmaintained
  disable! date: "2027-04-15", because: :unmaintained

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    inreplace "Cargo.toml", "0.0.0-UNSTABLE", version.to_s
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kty -V")

    assert_match "failed to read an incluster environment variable",
                 shell_output("#{bin}/kty users check brew 2>&1", 1)
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 26df940..fcf58af 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2494,9 +2494,9 @@ checksum = "c08d65885ee38876c4f86fa503fb49d7b507c2b62552df7c70b2fce627e06381"
 
 [[package]]
 name = "openssl"
-version = "0.10.66"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9529f4786b70a3e8c61e11179af17ab6188ad8d0ded78c5529441ed39d4bd9c1"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.6.0",
  "cfg-if",
@@ -2526,9 +2526,9 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.103"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7f9e8deee91df40a943c71b917e5874b951d32a802526c85721ce3b776c929d6"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
