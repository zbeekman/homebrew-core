class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://github.com/protonpass/pass-cli/archive/refs/tags/2.5.1.tar.gz"
  sha256 "cd7df559f428f04010d5f3d940accf0765c2acd57c7f5e54f3a8701affc9d662"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a4931d2ddfd8e10bcd4dab8c88ea8ef82c975059b08f4ab1fd5927fb60b0843e"
    sha256 cellar: :any, arm64_tahoe:       "4a4f15c6658c00dc05b02eeed347075557df51494bdaf6d76e5c708a74ea4853"
    sha256 cellar: :any, arm64_sequoia:     "3ea5dacf92b4aca19ca7a014a5b1e999ec952ec73d1ea5504986831cd580fd96"
    sha256 cellar: :any, arm64_linux:       "dc633f5a38ca787b91c12d8f319586f06a1c3af6a5a9b2177a952a334f15d679"
    sha256 cellar: :any, x86_64_linux:      "4563d67c130399852bcb1ff90d212d673a769c9fb181ce224f3791a9bfe8976f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  # Upstream does not currently accept external contributions.
  # Remove `pass-uniffi-bindgen` crate
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    ENV["PROTON_PASS_KEY_PROVIDER"] = "fs"
    output_log = testpath/"output.log"
    pid = spawn bin/"pass-cli", "login", [:out, :err] => output_log.to_s
    sleep 5
    assert_match "Waiting for authentication to complete", output_log.read
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 5ad67d3..0eeff1f 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1123,16 +1123,6 @@ dependencies = [
  "crossbeam-utils",
 ]
 
-[[package]]
-name = "console_error_panic_hook"
-version = "0.1.7"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a06aeb73f470f66dcdbf7223caeebb85984942f22f1adb2a088cf9668146bbbc"
-dependencies = [
- "cfg-if",
- "wasm-bindgen",
-]
-
 [[package]]
 name = "const-oid"
 version = "0.9.6"
@@ -4320,47 +4310,6 @@ dependencies = [
  "tokio",
 ]
 
-[[package]]
-name = "pass-mobile-sdk"
-version = "2.5.1"
-dependencies = [
- "anyhow",
- "async-trait",
- "pass",
- "serde",
- "serde_json",
- "tracing",
- "tracing-subscriber",
- "uniffi",
-]
-
-[[package]]
-name = "pass-uniffi-bindgen"
-version = "2.5.1"
-dependencies = [
- "uniffi",
-]
-
-[[package]]
-name = "pass-web-sdk"
-version = "2.5.1"
-dependencies = [
- "anyhow",
- "async-trait",
- "console_error_panic_hook",
- "js-sys",
- "pass",
- "send_wrapper",
- "serde",
- "serde-wasm-bindgen",
- "time",
- "tracing",
- "tracing-subscriber",
- "tsify",
- "wasm-bindgen",
- "wasm-bindgen-futures",
-]
-
 [[package]]
 name = "passkey"
 version = "0.5.0"
@@ -5977,15 +5926,6 @@ dependencies = [
  "serde_core",
 ]
 
-[[package]]
-name = "send_wrapper"
-version = "0.6.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "cd0b0ec5f1c1ca621c432a25813d8d60c88abe6d3e08a3eb9cf37d97a0fe3d73"
-dependencies = [
- "futures-core",
-]
-
 [[package]]
 name = "serde"
 version = "1.0.229"
@@ -7237,9 +7177,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "76407f5f396a2c949a069eff4a9fca9ce462410eb872bffef4c2b7b89804a77a"
 dependencies = [
  "anyhow",
- "camino",
  "cargo_metadata",
- "clap",
  "uniffi_bindgen",
  "uniffi_core",
  "uniffi_macros",
diff --git a/Cargo.toml b/Cargo.toml
index fbaeea3..65afb38 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -8,8 +8,6 @@ default-members = [
     "pass-fs",
     "pass",
     "pass-derive",
-    # maturin runs its `uniffi-bindgen` bin (in the default members) to generate the Python bindings
-    "pass-uniffi-bindgen"
 ]
 resolver = "2"
 
