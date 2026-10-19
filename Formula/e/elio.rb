class Elio < Formula
  desc "Batteries-included terminal file manager with rich previews"
  homepage "https://elio-fm.github.io/"
  url "https://github.com/elio-fm/elio/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "7a78b104e48f94a0460333a02f5e5f3a95dad11ec21a24e2b0be69d6e1974799"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7811b0195816ebd1327ddc0d6493d5ed030971d1591f5a4ffb8062ccea48777"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "25107ed60e6b22a86564dcdd27b625bec4b91ddbb3b96c6b8c42931e8d6fe7f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed9af6af6b0cbb68b987fd3082071d4b199dedcfc06323ea0a397ed027b6d788"
    sha256 cellar: :any,                 arm64_linux:       "e8e0ce301b19f47b5b97bd057cb67fb822864121b5822d83c39ead1756cdee06"
    sha256 cellar: :any,                 x86_64_linux:      "f106d0162f6a95e8d2b6a43c7e379cda26c7c086be851c5128636ec0e3892f90"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    missing = testpath/"missing-directory"
    output = shell_output("#{bin}/elio #{missing} 2>&1", 1)
    assert_match "no such file or directory", output
  end
end
