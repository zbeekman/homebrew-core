class Gittype < Formula
  desc "CLI code-typing game that turns your source code into typing challenges"
  homepage "https://github.com/unhappychoice/gittype"
  url "https://github.com/unhappychoice/gittype/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "49d734b079854549380e4048ac1894112736c5b8fb848957ab1e2d3d6cd4a534"
  license "MIT"
  head "https://github.com/unhappychoice/gittype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6106a00bd2c68edf9a7ed508e65aac5e761066ea98b409fa053648de05682c71"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "daf35c11a015224e02ffa675665a61c41121c92a1aa172bdcb7019456d894f63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cad5bf09fb5f416be3fdf2d08f41e065ed8524f61ae874a94a2e19422d5e9efe"
    sha256 cellar: :any,                 arm64_linux:       "51890981b8ad6b55207e1874784c6b98ff065207ac5ddbca56fea88cbf907942"
    sha256 cellar: :any,                 x86_64_linux:      "ec17919046a57032bcfe142b88a9a8b8e4b04aaac5c2fb3d094d377abe778c90"
  end

  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `cargo update --precise 0.9.114 openssl-sys` for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    # TODO: Remove when Rust's trait solver no longer hangs compiling the Shaku module.
    # https://github.com/rust-lang/rust/issues/151723
    # Upstream uses Rust 1.98.1: https://github.com/unhappychoice/gittype/commit/eed13acb1520925f46ff118f2e401b82d3e40cbe
    ENV["RUSTC_BOOTSTRAP"] = "1"
    ENV.append "RUSTFLAGS", "-Znext-solver=no"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gittype --version")

    %w[history stats export].each do |cmd|
      output = shell_output("#{bin}/gittype #{cmd} 2>&1", 1)
      assert_match "command is not yet implemented", output
    end

    output = shell_output("#{bin}/gittype repo list 2>&1", 1)
    assert_match "Error: Terminal error: Not running in a terminal environment", output
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 692a8d3..358932b 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2173,9 +2173,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.111"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "82cab2d520aa75e3c58898289429321eb788c3106963d0dc886ec7a5f4adc321"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
