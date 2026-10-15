class ScryerProlog < Formula
  desc "Modern ISO Prolog implementation written mostly in Rust"
  homepage "https://www.scryer.pl"
  license "BSD-3-Clause"
  head "https://github.com/mthom/scryer-prolog.git", branch: "master"

  stable do
    url "https://github.com/mthom/scryer-prolog/archive/refs/tags/v0.10.0.tar.gz"
    sha256 "353eca4eea539e0a0eedb1572736bfcc64c5fb6fd2da3b8737c513ad62f60f3b"

    # Backport only the openssl and openssl-sys version updates from
    # https://github.com/mthom/scryer-prolog/commit/70d046499a7ecab6006e41d7340202efa1109aa0
    patch :DATA
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "499a332647aa0fdda2e8a040d40d3ad0c6248f55255a3b9a4277527c92d14074"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d48c0a73df9bf67c54bc855ed865155ad79f41a4561591ed3f7359c3e9d2022d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da512766a1a27fe22eb01c1ae6a7c89dd934425d2388d1d482512689fedebd6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b08c3101dbe3c77c75ab5025e9a4d2fc49c2ed1f17a9839d7357d6972db614db"
    sha256 cellar: :any_skip_relocation, sonoma:            "ff71107fc21ebf2fad8c3be28b9801f65fba480207d8300af56b8df3975f5c1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5e3d6f8f168ef2b0bdd2c27755d68f1d6a8133fe9740e52d4914c509fca6e5fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "549989dbd09c1d6885e73357b5f2ba49e762bcbd3eaa0d35110832b0719db02e"
  end

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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.pl").write <<~PL
      test :-
        write('Hello from Scryer Prolog').
    PL

    assert_equal "Hello from Scryer Prolog", shell_output("#{bin}/scryer-prolog -g 'test,halt' #{testpath}/test.pl")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 4fa61925..903db1d3 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1949,15 +1949,14 @@ checksum = "d6790f58c7ff633d8771f42965289203411a5e5c68388703c06e14f24770b41e"
 
 [[package]]
 name = "openssl"
-version = "0.10.72"
+version = "0.10.80"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fedfea7d58a1f73118430a55da6a286e7b044961736ce96a16a17068ea25e5da"
+checksum = "a45fa2aa886c42762255da344f0a0d313e254066c46aad76f300c3d3da62d967"
 dependencies = [
  "bitflags 2.9.0",
  "cfg-if",
  "foreign-types",
  "libc",
- "once_cell",
  "openssl-macros",
  "openssl-sys",
 ]
@@ -1981,9 +1980,9 @@ checksum = "d05e27ee213611ffe7d6348b942e8f942b37114c00cc03cec254295a4a17852e"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.108"
+version = "0.9.116"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e145e1651e858e820e4860f7b9c5e169bc1d8ce1c86043be79fa7b7634821847"
+checksum = "f28a22dc7140cda5f096e5e7724a6962ca81a7f8bfd2979f9b18c11af56318c4"
 dependencies = [
  "cc",
  "libc",
