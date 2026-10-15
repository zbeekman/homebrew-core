class Intermodal < Formula
  desc "Command-line utility for BitTorrent torrent file creation, verification, etc."
  homepage "https://imdl.io"
  url "https://github.com/casey/intermodal/archive/refs/tags/v0.1.16.tar.gz"
  sha256 "3a072929379ddba929d85a579888ac51cf22e44897b7dc84af7612f49d3874d7"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b08d23c2cd1393295a670d32edc4d4776b5e2d5124574cbb27a332e66a3b202"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f873e05c4b6c00717b18cd0b49248cc9d126b6aa37232a0d9de2228b4cd0907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "53009e91234fdb3598c91b82e6b9986f56c06468b40653fa04cbd131340c5fd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "d2f1d0bd08f541bd0c7d4e40d05e9a55b85d7ecf5415ac46af4ed6838b46aabe"
    sha256 cellar: :any_skip_relocation, sonoma:            "d9a681fa9cb105b9b7de1d3d6be81dd5858da7fefd52331e552154c98647b3c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e1d91a49b2e5b2b1687de635be27e3406d0124dc57f2b78f5febcade82bf84ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "40616ffe3acc0e553d24b803f8c5234c5013127b49f4ab18452fc9565861a887"
  end

  depends_on "help2man" => :build
  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  # Update to openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "run", "--package", "gen", "--", "--bin", bin/"imdl", "man"
    generate_completions_from_executable(bin/"imdl", "completions")

    man1.install Dir["target/gen/man/*.1"]
  end

  test do
    system bin/"imdl", "torrent", "create", "--input", test_fixtures("test.flac"), "--output", "test.torrent"
    system bin/"imdl", "torrent", "verify", "--content", test_fixtures("test.flac"), "--input", "test.torrent"
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 0cc8c5c..c1e74d4 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1256,9 +1256,9 @@ checksum = "d05e27ee213611ffe7d6348b942e8f942b37114c00cc03cec254295a4a17852e"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.112"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "57d55af3b3e226502be1526dfdba67ab0e9c96fc293004e79576b2b9edb0dbdb"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
