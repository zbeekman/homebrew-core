class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "6f1f3466319ea5485b9d6f05000718c6ccbe1210c1cea7b2af83a5343d068a23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff258dcddcaaa7dec2bb87d79a005ba0cfa0bda0b26698a6229b81c7dbeadb5a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf3d55e45eb9afabc85f7c67eae77c6709d1fc4a8185778623123a80122c6c28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ab47077afdd89da24c43701285b8c72907793e5f8c37c45937d658477468b78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "48a383c603dd30adc6c913746686c4e7ffa734b7a5891e0fa26ec70a7e3d763a"
    sha256 cellar: :any_skip_relocation, sonoma:            "71c0e2331a9c2181491888c1bc1c76aadd6ee454fea4c872115ae661ea2abd19"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2352ef2c7a4f221b5ab323274e35ff40793ec3d787a0daf8744637645b7467f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "20afd4144eff9917898c9708e1073c071c27a5a8b4dfff6ba65f211b86862c9c"
  end

  depends_on "openssl@4" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "miniserve" => :test

  on_linux do
    depends_on "openssl@4"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args

    bash_completion.install "shell_completions/feroxbuster.bash" => "feroxbuster"
    fish_completion.install "shell_completions/feroxbuster.fish"
    zsh_completion.install "shell_completions/_feroxbuster"
  end

  test do
    (testpath/"wordlist").write <<~EOS
      a.txt
      b.txt
    EOS

    (testpath/"web").mkpath
    (testpath/"web/a.txt").write "a"
    (testpath/"web/b.txt").write "b"

    port = free_port
    pid = spawn "miniserve", testpath/"web", "-i", "127.0.0.1", "--port", port.to_s

    begin
      sleep 1
      system bin/"feroxbuster", "-q", "-w", testpath/"wordlist", "-u", "http://127.0.0.1:#{port}"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 0af50e8..443710b 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2227,9 +2227,9 @@ checksum = "a4895175b425cb1f87721b59f0f286c2092bd4af812243672510e1ac53e2e0ad"
 
 [[package]]
 name = "openssl"
-version = "0.10.73"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8505734d46c8ab1e19a1dce3aef597ad87dcb4c37e7188231769bd6bd51cebf8"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags",
  "cfg-if",
@@ -2274,9 +2274,9 @@ dependencies = [
 
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
