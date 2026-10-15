class Gitlogue < Formula
  desc "Cinematic Git commit replay tool"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "57925fead2e74773e45cd268d4c4905c8ef4856b642141411f58a3e36bee76c9"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0043462f51f643e4b1b8659dc709422f40ba9cc6c00e3528d72be4044de323e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "926240b8292dbdbcc4abf22b8d0797a0bdcaf6368b22d38bd8a010e5fff64c5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "14416a7e7045b9d37959e4b0c8e200fcdc21f0887cdeb2cdbc4592325057d2f2"
    sha256 cellar: :any,                 arm64_linux:       "73ed3fb7273602bc78ff0f3598dd9f6da14741f446961c76abfed2ad270194c3"
    sha256 cellar: :any,                 x86_64_linux:      "0f7bf685745076690d66f12ea33a01bba18aba0da1eaf353f5e1b40bede922e3"
  end

  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Update to openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  # Issue ref: https://github.com/unhappychoice/gitlogue/issues/226
  patch :DATA

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")

    assert_match "Error: Not a Git repository", shell_output("#{bin}/gitlogue 2>&1", 1)
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 698ae5b..ce63719 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1197,9 +1197,9 @@ dependencies = [
 
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
