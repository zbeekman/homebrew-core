class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunk-rs.github.io/trunk"
  url "https://github.com/trunk-rs/trunk/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "68bb132c7f827ed40d31948432dd4175f7d16aa745f175b9321987123d9d236b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e95ad475c49fbb5322fbbf9549f355f97607f428281812926ce6faffb3821999"
    sha256 cellar: :any, arm64_tahoe:       "cf27a8172e41b8e9ea3f63ce101410665baee65b32ca846854978d21c2f5b5f0"
    sha256 cellar: :any, arm64_sequoia:     "09f4a6c46d1eb6becd97ec0c154116e8b7df5df4006536f5e3ce6ddcb649597e"
    sha256 cellar: :any, arm64_linux:       "9e8758050043ef587c8389de3f576acbe8e4ae023b1a2856bbae469416aebe4b"
    sha256 cellar: :any, x86_64_linux:      "03ed23f22eb0b77134230c94b7ab48df3a76342b70965b508d25f6ccf9b7c07a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "bzip2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    # For features, we disable update_check and replace rustls with native-tls
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "native-tls")
  end

  test do
    ENV["TRUNK_CONFIG"] = testpath/"Trunk.toml"
    (testpath/"Trunk.toml").write <<~TOML
      trunk-version = ">=0.19.0"

      [build]
      target = "index.html"
      dist = "dist"
    TOML

    assert_match "Configuration {\n", shell_output("#{bin}/trunk config show")

    assert_match version.to_s, shell_output("#{bin}/trunk --version")
  end
end
