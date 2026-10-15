class SequoiaChameleonGnupg < Formula
  desc "Reimplementatilon of gpg and gpgv using Sequoia"
  homepage "https://sequoia-pgp.org"
  license "GPL-3.0-or-later"
  revision 1

  stable do
    url "https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg/-/archive/v0.13.1/sequoia-chameleon-gnupg-v0.13.1.tar.bz2"
    sha256 "8e204784c83b2f17cdd591bd9e2e3df01f9f68527bb5c97aa181c8bec5c6f857"

    # Backport only the openssl and openssl-sys version updates from
    # https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg/-/commit/c0e62cad4f6c7594f18a8fd854fee6a91652f01d
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "9b9bbe3336d6885d747b193ae71ee2d177de99e41e3e89439b893bf4c20ca593"
    sha256 cellar: :any,                 arm64_tahoe:       "61d7aec3f79054bece9da5f074cd523f76a5eae6a833d571d297c9a8cec830a0"
    sha256 cellar: :any,                 arm64_sequoia:     "2311543687172f7d8344999c541536ac205311176819910b598ee9cd8d84431b"
    sha256 cellar: :any,                 arm64_sonoma:      "de741debb4bea7b839d94e20a92332db0320c2b8bfe8a6492a0908313a7db371"
    sha256 cellar: :any,                 sonoma:            "01d2c0ab94f7fc524efe45f550dc9a8dfdc639885a215ac7b5a22b46397469ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c52d89c0162ecd6f5d998088684dc5279db8aaacf023dc2f2f92747a90abb832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ebf8923298bf97bc5e41aae618e275eb9b5b34fc3669411659d26f7f7513567e"
  end

  head do
    url "https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg.git", branch: "main"
    depends_on "capnp" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@4"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    ENV["ASSET_OUT_DIR"] = buildpath

    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "crypto-openssl")
    man1.install Dir["man-pages/*.1"]

    zsh_completion.install "shell-completions/_gpg-sq"
    zsh_completion.install "shell-completions/_gpgv-sq"
    bash_completion.install "shell-completions/gpg-sq.bash" => "gpg-sq"
    bash_completion.install "shell-completions/gpgv-sq.bash" => "gpgv-sq"
    fish_completion.install "shell-completions/gpg-sq.fish"
    fish_completion.install "shell-completions/gpgv-sq.fish"
  end

  test do
    assert_match "Chameleon #{version}", shell_output("#{bin}/gpg-sq --version")

    output = pipe_output("#{bin}/gpg-sq --enarmor", test_fixtures("test.gif").read, 0)
    assert_match "R0lGODdhAQABAPAAAAAAAAAAACwAAAAAAQABAAACAkQBADs=", output
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 410f74e..47ef6d6 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2158,15 +2158,14 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.69"
+version = "0.10.81"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f5e534d133a060a3c19daec1eb3e98ec6f4685978834f2dbadfe2ec215bab64e"
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
@@ -2190,9 +2189,9 @@ checksum = "d05e27ee213611ffe7d6348b942e8f942b37114c00cc03cec254295a4a17852e"
 
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
