class Meli < Formula
  desc "Terminal e-mail client and e-mail client library"
  homepage "https://meli-email.org/"
  url "https://git.meli-email.org/meli/meli/archive/v0.8.13.tar.gz"
  sha256 "b1414defb7973a96ed0510b5cb888aa8671fe4f3f832c5baa0c79dcd61ba2edf"
  license any_of: ["EUPL-1.2", "GPL-3.0-or-later"]

  livecheck do
    url "https://git.meli-email.org/meli/meli.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "06b2859929b7760ce694c1a388aa0dc267111c024263639cc859de96a00ea89b"
    sha256 cellar: :any,                 arm64_tahoe:       "5784a603ab62624ab0f093ccc3f407c5390841ea780dedd72e3cbbcb87943259"
    sha256 cellar: :any,                 arm64_sequoia:     "217a27feab49a34548a1ba893647f7b9a899513ba0b63897475e28d212bf3b6a"
    sha256 cellar: :any,                 arm64_sonoma:      "b66fa0a475e1b0bfb810e3d579eb1b129c1475afb9443e254f076e71342203af"
    sha256 cellar: :any,                 sonoma:            "a1c21bf8bfe2800cd52c7f3d23dc76871b99635578defaed3db7f43064f88d4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c6aab574892fb5e9ef1b2654b840e94c364f4981086e5c7ba84ed4b477438700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "df9bb9511f829b1e9773a7d20f8998945daad30be756da93ebc6ae0306f0b6da"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
  depends_on "sqlite" # needs `sqlite3_unlock_notify`

  uses_from_macos "curl"

  on_linux do
    depends_on "dbus"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"

    # Remove static feature from default features
    features = %w[
      sqlite3
      notmuch
      smtp
      dbus-notifications
      gpgme
      cli-docs
      jmap
    ]
    features += %w[http sequoia] if build.head?

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "meli", features:)

    man1.install "meli/docs/meli.1"
    man5.install Dir["meli/docs/*.5"]
    man7.install "meli/docs/meli.7"
  end

  test do
    output = shell_output("#{bin}/meli print-config-path")
    assert_match (testpath/".config/meli/config.toml").to_s, output

    assert_match version.to_s, shell_output("#{bin}/meli --version")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index c35ceb28..7337ba1e 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2277,9 +2277,9 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.73"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8505734d46c8ab1e19a1dce3aef597ad87dcb4c37e7188231769bd6bd51cebf8"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.10.0",
  "cfg-if",
@@ -2318,9 +2318,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.109"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "90096e2e47630d78b7d1c20952dc621f957103f8bc2c8359ec81290d75238571"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
