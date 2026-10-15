class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunk-rs.github.io/trunk"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  stable do
    url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.21.14.tar.gz"
    sha256 "8687bcf96bdc4decee88458745bbb760ad31dfd109e955cf455c2b64caeeae2f"

    # Backport only the openssl and openssl-sys version updates from
    # https://github.com/trunk-rs/trunk/commit/84105e44e2dc0d4ee6a218c0be0030c4bd1e6860
    patch :DATA
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8caf44575088962f9fc0ecb827ffa76b02d7d2039ea5549ea3e19a685c3395f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93022640040f9f21249a52ac60776e812e0aed4a02b9e0b61676eb8b51ac6f96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f29f737a25367f9d601004ab3c69d5af49388d105dbbf4de4342e9b26bb19235"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6e353a529700001a2d583d8b5c7b64fd33437b62cb06df847d87be200750a7d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "f527d08ece51ec56bc8f5cab717340954024b412c948739ae4dba0f5aa5c203e"
    sha256 cellar: :any_skip_relocation, sonoma:            "327a4675ef5bbe597bb701f9bf8fae1f5c0a5158a9b6e6b995e0beadd480adf6"
    sha256 cellar: :any_skip_relocation, ventura:           "1a95cdffa128c65c96942b7d28b0037c230ee87f89c426253665068717bfed7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4f03d00804c927fda2616c5ac7ad5a145bf84e361d6b36369a6fc4383562006d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "75d36fb9a7d305547ce7580004d3da051ddd6089a8338fff63e2a033efb17578"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "bzip2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    # For features, we disable update_check and replace rustls with native-tls
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "native-tls")
  end

  test do
    ENV["TRUNK_CONFIG"] = testpath/"Trunk.toml"
    (testpath/"Trunk.toml").write <<~TOML
      trunk-version = ">=0.19.0"

      [build]
      target = "index.html"
      dist = "dist"
    TOML

    assert_match "Configuration {\n", shell_output("#{bin}/trunk config show")

    assert_match version.to_s, shell_output("#{bin}/trunk --version")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index a0a353e..ce6fc55 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2445,15 +2445,14 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.72"
+version = "0.10.81"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fedfea7d58a1f73118430a55da6a286e7b044961736ce96a16a17068ea25e5da"
+checksum = "77823a27f0babb03091cb9ed9ef80af3b39dbc82f97e8fa530374b7dafd87a45"
 dependencies = [
  "bitflags 2.9.0",
  "cfg-if",
  "foreign-types",
  "libc",
- "once_cell",
  "openssl-macros",
  "openssl-sys",
 ]
@@ -2486,9 +2485,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.107"
+version = "0.9.117"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8288979acd84749c744a9014b4382d42b8f7b2592847b5afb2ed29e5d16ede07"
+checksum = "b47e7e6bb2c38cd930d25a23b40fa52e068c10e85f3e03a7f5ba5aaca5713695"
 dependencies = [
  "cc",
  "libc",
