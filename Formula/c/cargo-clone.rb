class CargoClone < Formula
  desc "Cargo subcommand to fetch the source code of a Rust crate"
  homepage "https://github.com/JanLikar/cargo-clone"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/JanLikar/cargo-clone.git", branch: "master"

  stable do
    url "https://github.com/JanLikar/cargo-clone/archive/refs/tags/v1.2.4.tar.gz"
    sha256 "58e86bd3440fc103572f6d8ff20ff1f99cf1e676cddb29975f204a9cb03f5b14"

    # Backport https://github.com/JanLikar/cargo-clone/commit/dfc2515d5befb78e2311b7eadfa02fb83d308144
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_golden_gate: "a8baf46e66fe2c4179b8dab2332d987e6ab00fce13d07d1560d26bbd427a9e2c"
    sha256 cellar: :any,                 arm64_tahoe:       "c4b544b37b9b657f7f9e9b5f50c8abea0644c9fd5df85cfb10fef27737b3c9df"
    sha256 cellar: :any,                 arm64_sequoia:     "2dcb5c906b3dd8b3b1d47c1a45c6c9ab40b6629de4990ede4c4b2c449e0f1a4a"
    sha256 cellar: :any,                 arm64_sonoma:      "7ef9e538a557821c7115fe2c2f086f6100ffad8926e8d5b152f536fba835cfa3"
    sha256 cellar: :any,                 sonoma:            "ac4cdb2157e0900e10ae7654549ea3e94563bd2fad05e73306044418ba16ee98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4f91abbdb2155fc427a28a51d9fc630fcc3fadb4aa75f3f2ce28f56c802679a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "43fe9543e5d0f96866f232b945c9524e4d516c41ef049f1aa39ffb6fe1ae8bfc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@4"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args(path: "cargo-clone")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    require "utils/linkage"

    system "cargo", "clone", "clone", "git2"
    assert_path_exists "git2/Cargo.lock"

    dylibs = [
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
      formula_opt_lib("openssl@4")/shared_library("libssl"),
    ]
    dylibs << (formula_opt_lib("curl")/shared_library("libcurl")) if OS.linux?

    dylibs.each do |library|
      assert Utils.binary_linked_to_library?(bin/"cargo-clone", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 95084db..4f76fec 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2440,15 +2440,14 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.57"
+version = "0.10.81"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bac25ee399abb46215765b1cb35bc0212377e58a061560d8b29b024fd0430e7c"
+checksum = "77823a27f0babb03091cb9ed9ef80af3b39dbc82f97e8fa530374b7dafd87a45"
 dependencies = [
  "bitflags",
  "cfg-if",
  "foreign-types",
  "libc",
- "once_cell",
  "openssl-macros",
  "openssl-sys",
 ]
@@ -2481,9 +2480,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.104"
+version = "0.9.117"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "45abf306cbf99debc8195b66b7346498d7b10c210de50418b5ccd7ceba08c741"
+checksum = "b47e7e6bb2c38cd930d25a23b40fa52e068c10e85f3e03a7f5ba5aaca5713695"
 dependencies = [
  "cc",
  "libc",
