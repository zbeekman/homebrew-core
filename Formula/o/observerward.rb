class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https://blog.kali-team.cn/projects/observer_ward/"
  url "https://github.com/emo-crab/observer_ward/archive/refs/tags/v2026.6.28.tar.gz"
  sha256 "36be8c3c6e6169eb5dfff450fe9d16372dac5a5a8b5d47a6c466555772bd7f74"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ecdf96da815ab98c47599168466d59e5081da9a9843da3a8e9a749c3d3ef318c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9825575a78113abeabf89a51985bf1bcfe20c792940efd3dd1bbd44a35a530c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e02a422bfd0ab15902bb0e08590c767f8219c927f2c5404befe10d6f44501b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "edb1ae3285315a6cf70a59bde39a7ed8cad4d3764cf72dcb1053d71ba3da91f5"
    sha256 cellar: :any_skip_relocation, sonoma:            "512245263439b46fb241e130e59340d82c2d8ef119e64c81b68ed4fff0d8ea5e"
    sha256 cellar: :any,                 arm64_linux:       "5092d36a7d056ea3b7267e9ef56e33f1e202d6a2a9fbda72ebff340a4bc9f62c"
    sha256 cellar: :any,                 x86_64_linux:      "f7a31d6341359b76dfac2fc38e2f0fad5d2ca65c790af656614aec7044a31d27"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  def install
    rm ".cargo/config.toml" # disable `+crc-static`
    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utils/linkage"

    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index d2a52ba..a4591b9 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2298,9 +2298,9 @@ checksum = "9f7c3e4beb33f85d45ae3e3a1792185706c8e16d043238c593331cc7cd313b50"
 
 [[package]]
 name = "openssl"
-version = "0.10.76"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "951c002c75e16ea2c65b8c7e4d3d51d5530d8dfa7d060b4776828c88cfb18ecf"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags",
  "cfg-if",
@@ -2345,9 +2345,9 @@ dependencies = [
 
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
