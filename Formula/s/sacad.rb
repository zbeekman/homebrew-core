class Sacad < Formula
  desc "Automatic cover art downloader"
  homepage "https://github.com/desbma/sacad"
  url "https://github.com/desbma/sacad/archive/refs/tags/3.0.3.tar.gz"
  sha256 "747a2b3847c85ad55f4b8ef53b9a133003c53ad9e3c644e74ed762756b613748"
  license "MPL-2.0"
  head "https://github.com/desbma/sacad.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f130e55956cbb35bb06979709048aa5bd01b3ba6afa1793d084230c4eedbe8b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb4165db1738e3d5f9c9881ae5311d6a8322c8f9f2c7a30f3e28a6347aa5bfc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6e604177f4cfd0f698cf05dfad53dff586cf730a9e564ed44d359f3c8855996"
    sha256 cellar: :any,                 arm64_linux:       "d4573de9dc0c95e17b65adfbbc11f19dd22623a9e20ee31492de08adec0e8c5f"
    sha256 cellar: :any,                 x86_64_linux:      "6561ae070b0c437f8210110d72f888f988f74c11892033d5db42dbc46b6f0eca"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sacad --version")
    system bin/"sacad", "metallica", "master of puppets", "600", "AlbumArt.jpg"
  end
end
