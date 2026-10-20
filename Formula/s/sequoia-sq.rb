class SequoiaSq < Formula
  desc "Sequoia-PGP command-line tool"
  homepage "https://sequoia-pgp.org"
  url "https://static.crates.io/crates/sequoia-sq/sequoia-sq-1.5.0.crate"
  sha256 "43f230abc78a8daec8a06cfc8c1191045b7b210fee5bee50dc3f75bd9f22950e"
  license "LGPL-2.0-or-later"
  head "https://gitlab.com/sequoia-pgp/sequoia-sq.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "622f31af9956e3a8903c8817cc2bb1ff0043e24ed16c4de20e648b43ec898df4"
    sha256 cellar: :any, arm64_tahoe:       "8024c747ca5b7ba54c2f439729ae1dbbb7c9f26d5c78487e640ed04b3047d83c"
    sha256 cellar: :any, arm64_sequoia:     "9bb43b2aeae455aa329ca1b529f3a0e571d388ca26e378ef144c1addc169cc0c"
    sha256 cellar: :any, arm64_linux:       "4dbb45b4b8bf1a3110267ddd10bacc7b3d2519966680afc1ce23a4656f38e4d7"
    sha256 cellar: :any, x86_64_linux:      "6b377318dc71380cd0fe5ff03b18f7ee1818d0fa5630cd77d69731ea699205e5"
  end

  depends_on "capnp" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@4"

  uses_from_macos "llvm" => :build
  uses_from_macos "bzip2"
  uses_from_macos "sqlite"

  conflicts_with "sq", "squirrel-lang", because: "both install `sq` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    ENV["ASSET_OUT_DIR"] = buildpath

    path = build.head? ? "tool" : "."
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "crypto-openssl", path:)
    man1.install Dir["man-pages/*.1"]

    bash_completion.install "shell-completions/sq.bash" => "sq"
    zsh_completion.install "shell-completions/_sq"
    fish_completion.install "shell-completions/sq.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sq version 2>&1")

    output = pipe_output("#{bin}/sq packet armor", test_fixtures("test.gif").read, 0)
    assert_match "R0lGODdhAQABAPAAAAAAAAAAACwAAAAAAQABAAACAkQBADs=", output
  end
end
