class Dura < Formula
  desc "Backs up your work automatically via Git commits"
  homepage "https://github.com/tkellogg/dura"
  url "https://github.com/tkellogg/dura/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "6486afa167cc2c9b6b6646b9a3cb36e76c1a55e986f280607c8933a045d58cca"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_golden_gate: "0664210bfbe0f59362b59efae6acda42dd71d6ee7f200310ca744e16acda5aaa"
    sha256 cellar: :any,                 arm64_tahoe:       "04d67662331f277b9b5393600713ddfbe74e834add68af49d7a58badaad41840"
    sha256 cellar: :any,                 arm64_sequoia:     "54da4d8f9e32677a209421d476d4592dd2a9263f2af8d04de78a2d7aea450c8f"
    sha256 cellar: :any,                 arm64_sonoma:      "778b3a0e61b4dad5470c646c2c88826ac79f544fc4d3a704ba65fbd9dda8338a"
    sha256 cellar: :any,                 sonoma:            "03c924c660fd676488e9e1843237b37ff7e07cb929960f5b5eddb205db31c97f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "18daffe15b51f35e50bc3a3d70e9775aa4c525b8eaf98f8a8c6b509f77215dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "09767ecf799c0429b79c715025b0f92e384fb2847fafd8db0432edbf8a535da1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libssh2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Update to openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  deny_network_access!

  def fetch
    # Refresh the release's lockfile while retaining existing dependency versions.
    system "cargo", "update", "--workspace"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"dura", "serve"]
    keep_alive true
    error_log_path var/"log/dura.stderr.log"
    log_path var/"log/dura.log.json"
    working_dir var
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    assert_match(/commit_hash:\s+\h{40}/, shell_output("#{bin}/dura capture ."))
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index ced8285..e8862f3 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -670,11 +670,10 @@ checksum = "28988d872ab76095a6e6ac88d99b54fd267702734fd7ffe610ca27f533ddb95a"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.72"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7e46109c383602735fa0a2e48dd2b7c892b048e1bf69e5c3b1d804b7d9c203cb"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
- "autocfg",
  "cc",
  "libc",
  "pkg-config",
