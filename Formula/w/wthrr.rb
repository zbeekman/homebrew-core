class Wthrr < Formula
  desc "Weather Companion for the Terminal"
  homepage "https://github.com/ttytm/wthrr-the-weathercrab"
  license "MIT"
  head "https://github.com/ttytm/wthrr-the-weathercrab.git", branch: "main"

  stable do
    url "https://github.com/ttytm/wthrr-the-weathercrab/archive/refs/tags/v1.2.1.tar.gz"
    sha256 "ff5b47f2046ebefa9ff28cb52ece49a06f7b89230578801c338c77802aa721e0"

    # Backport renovate Cargo.lock updates
    patch do
      url "https://github.com/ttytm/wthrr-the-weathercrab/commit/2c7676460787022916450e9fdb94a3f917341898.patch?full_index=1"
      sha256 "68ef0be8b65982f63c785e3ad1c3f1dded4ae8e2e8cc100b3cd3ab8c1d396a0d"
      type :backport
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a2a1caf4f3f8670dda749e8781c5abe0c7e07a4d307132eba6500c9050ceefc0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "374e60034ee75ae89b1ed428b0fccd1af6283c04579823105c05da9edf09b77e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "762cc039b08678cc91207e5aba373a9926b4d7f6bd14b154080ec4c9f0144778"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "423b5d934ed4948e6f91ff46bb6122fe3ef4801357cbe1323abe055e63a4bac4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "a5c71252f0517231d9b7ea64314591586df9419d5529029c4ef1d7b6ca73b315"
    sha256 cellar: :any_skip_relocation, sonoma:            "c0a81d0cd757022468358c46c11db2ed9e34baefce396c4403ded61b65088f6e"
    sha256 cellar: :any_skip_relocation, ventura:           "6b4fdbcd8131123e488055b26f86a6ef912445e4a200b915a9ae4f561a45a753"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b2a3a3a1958b67645f20100308854792cc55ddf067a31f403bb251ccb5c2e28f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e0d8bda45cf33d2ec34c043302a42b9551d9d7c33dbdc0421c80ccb599db8219"
  end

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
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wthrr --version")
    system bin/"wthrr", "-h"

    require "pty"

    PTY.spawn(bin/"wthrr", "-l", "en_US", "Kyoto") do |r, _w, pid|
      output = r.gets
      assert_match "Hey friend. I'm glad you are asking.", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 1456628..50ae4e3 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -737,9 +737,9 @@ checksum = "1261fe7e33c73b354eab43b1273a57c8f967d0391e80353e51f764ac02cf6775"
 
 [[package]]
 name = "openssl"
-version = "0.10.68"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "6174bc48f102d208783c2c84bf931bb75927a617866870de8a4ea85597f871f5"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags",
  "cfg-if",
@@ -769,9 +769,9 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.104"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "45abf306cbf99debc8195b66b7346498d7b10c210de50418b5ccd7ceba08c741"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
