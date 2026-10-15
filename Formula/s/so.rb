class So < Formula
  desc "Terminal interface for StackOverflow"
  homepage "https://github.com/samtay/so"
  url "https://github.com/samtay/so/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "36d8bc53b9c05e242fd4c9ba8ae447fae6c4a35d8c7e071f8994a7c0f07c225d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09931ef4eefc1c057a8dc3f1ee7f81c4b57d7e1c491198f294aee703770fcc4e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d106bc00111838ead6bb1875827882b2b38271384a2b5d486163f8ec355be0a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82b3ba2bd29430167b84cbc7116ca22c70679e0c6a59b340c3349ead364c0e16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "4c26864040cdb083f702827d253cc9128d018f12eeeff0d4477908385c38eda3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "6e83c51f58acc449889bb035f202e9f0e9a4fe5b498c480c2a58e0982b93a820"
    sha256 cellar: :any_skip_relocation, arm64_monterey:    "ade232aa606461f6c6a8fd543f6d9048d52f8931d4ecb952d323ea5cfcc63bd0"
    sha256 cellar: :any_skip_relocation, sonoma:            "ffb713476e09d5bc6930cc1b550efd65d9556103f6641e2f2ca8bd9a8d9c374f"
    sha256 cellar: :any_skip_relocation, ventura:           "e80a401d20434c2716eb29d1a3b80ff9647ea7b00e6797a8d35b260e4f7cf6c8"
    sha256 cellar: :any_skip_relocation, monterey:          "72daa345f044b21902150324f5b8240d5625c96ae25a46f4696374da30965567"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a1477dceb51ed2cb6ba94b4f5755376fdaebcfe22b7301273120dede98403ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dff017b24e8061f4c5ea8b37e9f675d636449f6206735d130dcde4db047729b5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  conflicts_with "solod", because: "both install `so` binaries"

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"

    env_vars = { "LC_CTYPE" => "en_US.UTF-8", "LANG" => "en_US.UTF-8", "TERM" => "xterm" }
    opts = %w[--search-engine stackexchange --limit 1 --lucky]
    output_log = testpath/"output.log"
    PTY.spawn(env_vars, bin/"so", *opts, "how do I exit Vim", [:out, :err] => output_log.to_s) do |r, w, pid|
      r.winsize = [80, 130]
      sleep 3
      w.puts "q"
      sleep 2
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_match ":wq", output_log.read
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index a9d4dbc..e0c5824 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1567,9 +1567,9 @@ checksum = "b410bbe7e14ab526a0e86877eb47c6996a2bd7746f027ba551028c925390e4e9"
 
 [[package]]
 name = "openssl"
-version = "0.10.66"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "9529f4786b70a3e8c61e11179af17ab6188ad8d0ded78c5529441ed39d4bd9c1"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.6.0",
  "cfg-if",
@@ -1599,9 +1599,9 @@ checksum = "ff011a302c396a5197692431fc1948019154afc178baf7d8e37367442a4601cf"
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.103"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "7f9e8deee91df40a943c71b917e5874b951d32a802526c85721ce3b776c929d6"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",
