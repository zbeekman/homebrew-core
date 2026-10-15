class Tiny < Formula
  desc "Terminal IRC client"
  homepage "https://github.com/osa1/tiny"
  license "MIT"
  head "https://github.com/osa1/tiny.git", branch: "master"

  stable do
    url "https://github.com/osa1/tiny/archive/refs/tags/v0.13.0.tar.gz"
    sha256 "599697fa736d7500b093566a32204691093bd16abd76f43a76b761487a7c584c"

    # Backport some dependency updates
    patch do
      url "https://github.com/osa1/tiny/commit/2ee969a521608eb4f4bf3edefbf546f763019a4a.patch?full_index=1"
      sha256 "684534ce9e3555a8edc1438ff3fdd5b87eb8c3a264f62e9b93b2016b01ac7e02"
      type :backport
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e4bd30577800f34eb19cb911b8874ab5537839644dd63a41a196e873399c685"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f39273bea2d44c1f991cb568d3bb3caeec238629895d7332f93cc3fd8cb8a8c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b6362dac49c5a0b79b04dc91ded217ab137a122398a14dce062179667802278e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "670eea450b4070a2eb2984d25773a284faf38671fbb333ad4d131cecaf23be18"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "56f21368dff225e7fae151b96ded515ab2c858c6a4cbd8bb5f124c6964937d98"
    sha256 cellar: :any_skip_relocation, sonoma:            "d9c036c42cf375368d2668c63e52da17ffd3432f96729c41b685bcc0cfaeee87"
    sha256 cellar: :any_skip_relocation, ventura:           "7028b5c3c765572cf316d00e7fe552a37794e518e8cb0acaeb63c95eb8e90cf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5d245db5944104a25d7623ca20f447ae4a0960ad0ad085351efadb8f7cc4a51a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "82dba4c308ec8fd1b7185f7a92427f69dae4ca52a2c503088e8d284dd3746e1a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  def install
    # Replace tls-rustls with tls-native
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/tiny", features: "tls-native")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tiny --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"tiny", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "tiny couldn't find a config file", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 6f2e771..4a95afd 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -568,9 +568,9 @@ checksum = "42f5e15c9953c5e4ccceeb2e7382a716482c34515315f7b03532b8b4e8393d2d"
 
 [[package]]
 name = "openssl"
-version = "0.10.72"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fedfea7d58a1f73118430a55da6a286e7b044961736ce96a16a17068ea25e5da"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.9.1",
  "cfg-if",
@@ -600,9 +600,9 @@ checksum = "d05e27ee213611ffe7d6348b942e8f942b37114c00cc03cec254295a4a17852e"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.108"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "e145e1651e858e820e4860f7b9c5e169bc1d8ce1c86043be79fa7b7634821847"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
