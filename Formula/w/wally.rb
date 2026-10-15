class Wally < Formula
  desc "Modern package manager for Roblox projects inspired by Cargo"
  homepage "https://wally.run"
  license "MPL-2.0"
  head "https://github.com/UpliftGames/wally.git", branch: "main"

  stable do
    url "https://github.com/UpliftGames/wally/archive/refs/tags/v0.3.2.tar.gz"
    sha256 "f7da2a10865b05efe97273aa1d08e0efbb9d26fecb770d819bdc01fbb98a0ad9"

    # `cargo update openssl-sys --precise 0.9.117` and `cargo update openssl --precise 0.10.81`
    # to use versions in https://github.com/UpliftGames/wally/commit/1df8d8c9b218f7504dd9e1419383446ff18d77f8
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_golden_gate: "561453b3c6e574a6fb4f9e2aa36df545365f7c15b8560bf1e72555ab9dacf2fb"
    sha256 cellar: :any,                 arm64_tahoe:       "8c9d6350d3eefbe0f7ffdd8ae0e3848ecf54079dfffb4bb0dc820d41c802c2af"
    sha256 cellar: :any,                 arm64_sequoia:     "ac406b7fa1ecb8ea08e890b2f58f021bc966e7cc1073e8a57a4dbddfab32223b"
    sha256 cellar: :any,                 arm64_sonoma:      "f231366bd7b5e801852f98c63835485b66da481b7b867d527790575ac401aced"
    sha256 cellar: :any,                 sonoma:            "985950f162544863811b7bb0757f8dc945036d81d5c3ac4eb8592e10ea04d62f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e8ec8105b54551fc7277e01e3cbe506921aa0ec643c16722e58adf5fcf546668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6280085aae3f14cacdac8fd689cd77781132ce85b22afa0acae875c0e82811a3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `test do` block clones the package registry.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"wally.toml").write <<~TOML
      [package]
      name = "test/test"
      version = "0.1.0"
      license = "MIT"
      realm = "server"
      registry = "https://github.com/UpliftGames/wally-index"
      [dependencies]
    TOML

    system bin/"wally", "install"
    assert_path_exists testpath/"wally.lock"
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index e29ff77..3399b37 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1775,28 +1775,27 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.44"
+version = "0.10.81"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "29d971fd5722fec23977260f6e81aa67d2f22cadbdc2aa049f1022d9a3be1566"
+checksum = "77823a27f0babb03091cb9ed9ef80af3b39dbc82f97e8fa530374b7dafd87a45"
 dependencies = [
- "bitflags 1.3.2",
+ "bitflags 2.3.1",
  "cfg-if 1.0.0",
  "foreign-types",
  "libc",
- "once_cell",
  "openssl-macros",
  "openssl-sys",
 ]
 
 [[package]]
 name = "openssl-macros"
-version = "0.1.0"
+version = "0.1.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b501e44f11665960c7e7fcf062c7d96a14ade4aa98116c004b2e37b5be7d736c"
+checksum = "a948666b637a0f465e8564c73e89d4dde00d72d4d473cc972f390fc3dcee7d9c"
 dependencies = [
  "proc-macro2",
  "quote",
- "syn 1.0.67",
+ "syn 2.0.18",
 ]
 
 [[package]]
@@ -1807,11 +1806,10 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.79"
+version = "0.9.117"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "5454462c0eced1e97f2ec09036abc8da362e66802f66fd20f86854d9d8cbcbc4"
+checksum = "b47e7e6bb2c38cd930d25a23b40fa52e068c10e85f3e03a7f5ba5aaca5713695"
 dependencies = [
- "autocfg",
  "cc",
  "libc",
  "pkg-config",
@@ -3414,7 +3412,7 @@ version = "1.6.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "1f559b464de2e2bdabcac6a210d12e9b5a5973c251e102c44c585c71d51bd78e"
 dependencies = [
- "cfg-if 1.0.0",
+ "cfg-if 0.1.10",
  "static_assertions",
 ]
 
