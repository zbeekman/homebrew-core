class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/refs/tags/v2.11.6.tar.gz"
  sha256 "19390d1032cd2e10a7a589228fd035ab60b07f093a46e8a2bce4fa1c08f5e66b"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d51635c9861ccd6336c0c77e762d3bf3387d8b740eaab81b869d7bed34282a5f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95304b6a43ab7728cce9ffcc9bb0f8cdd43e19a663e15f70026b07402539341c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c8a53562522848e361f0a268d51b4467446ab5bafc6dc4006117e30f13320e0"
    sha256 cellar: :any,                 arm64_linux:       "161a2612fb4a9745b75a599ffd4fbedd3b7b7eca28451602f52aafcbfa05c918"
    sha256 cellar: :any,                 x86_64_linux:      "94a704905ffe16934d25526ef79a63b36af2d41283ec35cdcbd62431032d85fa"
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
