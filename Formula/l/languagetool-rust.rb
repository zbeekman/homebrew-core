class LanguagetoolRust < Formula
  desc "LanguageTool API in Rust"
  homepage "https://docs.rs/languagetool-rust"
  url "https://github.com/jeertmans/languagetool-rust/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "fc3dfcb73f21c58bb143b5f31495892755bc1e945aa64f522f3640e1cf77de31"
  license "MIT"
  head "https://github.com/jeertmans/languagetool-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2adf1fc7862206cde67e4d7a6f512abd85cb725fe38b1fe23e887d7cc9fbe063"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85ee9015416398103969d20ca8b24f1ba8f1565b41fbdbc4cfd2434f5fb579f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7bd12b90f7efce56e45d0edb3939203b37a2b59602424f0b31a562235477d9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "74439844b520fd1496af643238d7aca68bb451ae84540fba04ca950e15210286"
    sha256 cellar: :any_skip_relocation, sonoma:            "ff878a7ce6bad5b54eb2da7429f7c8369e7849b243e986f972e71b5289f004ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5d09aad8f14ff45e52e6056ef9ac7d5f549e2d4de21bdf83a9235d6c3fb7c2a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "075629cf87a0dfae2b2325ec87aa58e71a372bcdc04e8cf97a113e23c7a21d7d"
  end

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
    system "cargo", "install", *std_cargo_args(features: "full")

    generate_completions_from_executable(bin/"ltrs", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ltrs --version")

    system bin/"ltrs", "ping"
    assert_match '"name": "Arabic"', shell_output("#{bin}/ltrs languages")

    output = shell_output("#{bin}/ltrs check --text \"Some phrase with a smal mistake\"")
    assert_match "error[MORFOLOGIK_RULE_EN_US]: Possible spelling mistake found", output
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index f270356..602bba8 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1365,9 +1365,9 @@ checksum = "d6790f58c7ff633d8771f42965289203411a5e5c68388703c06e14f24770b41e"
 
 [[package]]
 name = "openssl"
-version = "0.10.74"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "24ad14dd45412269e1a30f52ad8f0664f0f4f4a89ee8fe28c3b3527021ebb654"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags",
  "cfg-if",
@@ -1406,9 +1406,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.110"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0a9f0075ba3c21b09f8e8b2026584b1d18d49388648f2fbbf3c97ea8deced8e2"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
