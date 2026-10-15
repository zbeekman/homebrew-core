class Rathole < Formula
  desc "Reverse proxy for NAT traversal"
  homepage "https://github.com/rathole-org/rathole"
  url "https://github.com/rathole-org/rathole/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "c8698dc507c4c2f7e0032be24cac42dd6656ac1c52269875d17957001aa2de41"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6fc21ef63516a0b578b691bc9eedaa46420d71e3de90b34ab82a9a3b4801b0cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3629eb8ca9900924fa60ca4732cb944f93362ac86259944539ca10beeffb867d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d668cd71d085b210e33c711837fc58c97fcfebf3417f0c3c7d722df711d45ae9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "bcb8141198492a1cafa8833e4b5b1f872a292b0b4a583de7f71aeeb6f3376b86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "e9dff11d616e36a7e3fb42bf83f8a0ba908382562fd5ab26abd4ab08a99f6c0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey:    "bff2c4cd4cbfd16cd46672656d6388613c4b2481d29c3774e7468a218378488e"
    sha256 cellar: :any_skip_relocation, sonoma:            "616f267223b7bc2142ec93df13af511a672fa8dd85ae1e114eb036a901a8623e"
    sha256 cellar: :any_skip_relocation, ventura:           "da508621aa73060eee88b3b1771c80aae6d593210575e15b4ed101b6dd60bd73"
    sha256 cellar: :any_skip_relocation, monterey:          "db9a05658116a968398b3f184a1e6bd63dc90ec3f7b56487d79d3210b6006846"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "104d1709ddbd8886b31e576ab1dcdc27b6c3a4705d203051da98257ba0fee777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "418e67c95c4f95329a0564f4fe78c4c8ff23bda1be98eed056a9ef45fc558b39"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # rust 1.80 build patch
  patch do
    file "Patches/rathole/rust-1.80.patch"
    type :unofficial
    resolves "https://github.com/rathole-org/rathole/issues/380"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  # Issue ref: https://github.com/rathole-org/rathole/issues/475
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"rathole", "#{etc}/rathole/rathole.toml"]
    keep_alive true
    log_path var/"log/rathole.log"
    error_log_path var/"log/rathole.log"
  end

  test do
    bind_port = free_port
    service_port = free_port

    (testpath/"rathole.toml").write <<~TOML
      [server]
      bind_addr = "127.0.0.1:#{bind_port}"#{" "}
      default_token = "1234"#{" "}

      [server.services.foo]
      bind_addr = "127.0.0.1:#{service_port}"
    TOML

    read, write = IO.pipe
    fork do
      exec bin/"rathole", "-s", testpath/"rathole.toml", out: write
    end
    sleep 5

    output = read.gets
    assert_match(/Listening at 127.0.0.1:#{bind_port}/i, output)

    assert_match(/Build Version:\s*#{version}/, shell_output("#{bin}/rathole --version"))
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 95fb8ac..099eb9d 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1294,9 +1294,9 @@ checksum = "624a8340c38c1b80fd549087862da4ba43e08858af025b236e509b6649fc13d5"
 
 [[package]]
 name = "openssl"
-version = "0.10.57"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bac25ee399abb46215765b1cb35bc0212377e58a061560d8b29b024fd0430e7c"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.4.0",
  "cfg-if",
@@ -1335,9 +1335,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.93"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "db4d56a4c0478783083cfafcc42493dd4a981d41669da64b4572a2a089b51b1d"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
