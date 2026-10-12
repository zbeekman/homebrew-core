class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/refs/tags/v2.11.4.tar.gz"
  sha256 "1d62676eff2172bce00addd725ba1a74a74a01c594f5ed9a616b67a7124e8fba"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66f9c591f02352cd4e8353986cb697e846fe63423f86c3893f274e19424e0f44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e22a4ac15b56215bf9d74ac18870ee56a6edd49d744c45d6737e49be2cabed04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9dad5207f5770651b5074870d9c560d2a0c515b072d05e6b7b3a1db21c9acf06"
    sha256 cellar: :any,                 arm64_linux:       "69c7f76fdc80345f9fcae3d1e251ee14bc2079fff23e5668218dcbaf1ef91925"
    sha256 cellar: :any,                 x86_64_linux:      "570a62f1db0c71f3edab05e4d98442c4bccf6e92d8a2f0f4d7586a3ebe60fd01"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
