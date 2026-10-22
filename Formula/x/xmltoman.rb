require "language/perl"

class Xmltoman < Formula
  include Language::Perl::Shebang

  desc "XML to manpage converter"
  homepage "https://sourceforge.net/projects/xmltoman/"
  url "https://downloads.sourceforge.net/project/xmltoman/xmltoman/xmltoman-0.4.tar.gz/xmltoman-0.4.tar.gz"
  sha256 "948794a316aaecd13add60e17e476beae86644d066cb60171fc6b779f2df14b0"
  license "GPL-2.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "997c2d4d56d3d69c761c1be4a6cc422b1b5e1e33a82bb365dcd84fed5b6ebe1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5da8397d661fb35e42adec8172bfdc0fbcb5370c59885ec9710f362951a0fd12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5da8397d661fb35e42adec8172bfdc0fbcb5370c59885ec9710f362951a0fd12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5da8397d661fb35e42adec8172bfdc0fbcb5370c59885ec9710f362951a0fd12"
    sha256 cellar: :any_skip_relocation, tahoe:             "5da8397d661fb35e42adec8172bfdc0fbcb5370c59885ec9710f362951a0fd12"
    sha256 cellar: :any_skip_relocation, sequoia:           "5da8397d661fb35e42adec8172bfdc0fbcb5370c59885ec9710f362951a0fd12"
    sha256 cellar: :any_skip_relocation, sonoma:            "5da8397d661fb35e42adec8172bfdc0fbcb5370c59885ec9710f362951a0fd12"
    sha256 cellar: :any,                 arm64_linux:       "bd5e21010f569948d6da34986ff3881e2befdacedd5c755005b0caa8b4ac4a3e"
    sha256 cellar: :any,                 x86_64_linux:      "13c53ad2a94fa4249c146a7d34a0b3127be4696b8f56dbd0f86aecc1671fb1cd"
  end

  uses_from_macos "perl"

  on_macos do
    depends_on "coreutils" => :build
  end

  on_linux do
    depends_on "perl-xml-parser"
  end

  def install
    ENV.prepend_path "PATH", formula_opt_libexec("coreutils")/"gnubin" if OS.mac?
    # Modify shebang to run xmltoman during build as automatic rewrite happens after install
    rewrite_shebang detected_perl_shebang, "xmltoman" if OS.linux?

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    man1.install "xmltoman.1", "xmlmantohtml.1"
  end

  test do
    assert_match "You need to specify a file to parse", shell_output("#{bin}/xmltoman 2>&1", 1).strip
  end
end
