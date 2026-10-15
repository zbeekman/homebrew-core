class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  stable do
    url "https://github.com/printfn/fend/archive/refs/tags/v1.5.8.tar.gz"
    sha256 "2c53922b83b693c852581942ddcf8e02e1bcd691f30c00e8066cdd6ab2070b86"

    # Backport openssl and openssl-sys updates to support OpenSSL 4
    # https://github.com/printfn/fend/commit/0f4c1bb1e5f6ae6ce655d3cc85608223112ed3d4
    patch :DATA
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fcf8d3537e958fdb539ce88724de8325b7de8e341a7f9b35fb2a5a6c0345e997"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db21c648244b0a4d53fef9aeb10d7d0dc3b640af0229eb3a986fa58955cf417c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "23a873fb4f16bfa2c049f65b7c68d7dc3ac9976a81a4191eec08b2bcd508c3f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "81f331397cacc008651ea31bb3a1618a1317eb11e4879cde6655036a86c7f4cb"
    sha256 cellar: :any_skip_relocation, sonoma:            "2c50f9bac90906163d04042ec31be34db7f24836f410c3a42685afa379d6dd15"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5783a60f33bce682339b2fcc8a74c80196895022b3dd0a08b15d678836963a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c3643edb40ac0aff3cf9cf5cc6a3733bfa2e5eb562ed959f11e93b7914ee1225"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli", features: "native-tls")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end

__END__
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -750,15 +750,14 @@ checksum = "42f5e15c9953c5e4ccceeb2e7382a716482c34515315f7b03532b8b4e8393d2d"
 
 [[package]]
 name = "openssl"
-version = "0.10.75"
+version = "0.10.80"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "08838db121398ad17ab8531ce9de97b244589089e290a384c900cb9ff7434328"
+checksum = "a45fa2aa886c42762255da344f0a0d313e254066c46aad76f300c3d3da62d967"
 dependencies = [
  "bitflags",
  "cfg-if",
  "foreign-types",
  "libc",
- "once_cell",
  "openssl-macros",
  "openssl-sys",
 ]
@@ -788,9 +787,9 @@ checksum = "7c87def4c32ab89d880effc9e097653c8da5d6ef28e6b539d313baaacfbafcbe"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.111"
+version = "0.9.116"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "82cab2d520aa75e3c58898289429321eb788c3106963d0dc886ec7a5f4adc321"
+checksum = "f28a22dc7140cda5f096e5e7724a6962ca81a7f8bfd2979f9b18c11af56318c4"
 dependencies = [
  "cc",
  "libc",
