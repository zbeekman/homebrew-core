class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.sourceforge.net/history.html
  # TODO: Upstream temporarily uses SourceForge due to issues with DreamHost. Check if they resolve this
  url "https://downloads.sourceforge.net/project/exiftool/Image-ExifTool-13.55.tar.gz"
  mirror "https://exiftool.org/Image-ExifTool-13.55.tar.gz"
  mirror "https://cpan.metacpan.org/authors/id/E/EX/EXIFTOOL/Image-ExifTool-13.55.tar.gz"
  sha256 "5f4c81d34ad406538c2871ad72dbfceb5d9b412b2f16cbbeb4d712d270846667"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  revision 1
  compatibility_version 1
  head "https://git.code.sf.net/p/exiftool/code.git", branch: "master"

  livecheck do
    url "https://exiftool.sourceforge.net/history.html"
    regex(/production\s+release\s+is.*?href=.*?Image[._-]ExifTool[._-]v?(\d+(?:\.\d+)+)\.t/im)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47b6b3ce9b5fbba219b1d82a52de43cb46f962c2efefe62dcba9eb51f1388437"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4477e036ab8db27aab707d35d077057d012637290604cd95e0aca0abae28da64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca96e03beb59ea8a21c56d9c952b83d02e0be1deade0e7d44a96c53801978ba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1415b75fe1832777026f05301fa89ce434bb19674280a8180f9484f9b639b3ae"
    sha256 cellar: :any_skip_relocation, tahoe:             "0a04ea42c344370d4bdff05f1be014e6b35ef9494421fc703467db4ccdbd5c91"
    sha256 cellar: :any_skip_relocation, sequoia:           "793ade378941a873bffae4db9e488a1e59cefd7ff8197df20bbfb526adf37988"
    sha256 cellar: :any_skip_relocation, sonoma:            "48c04ef21f26cc442b010f5d48053cd4fb0fdf87c1cb0c12da5649c774dadc78"
    sha256 cellar: :any,                 arm64_linux:       "7907dce88555b2a98c1fce6c2525975b5970915005d21f12134764cb8857d301"
    sha256 cellar: :any,                 x86_64_linux:      "bb8eeb6467f5a666187563c43f8e6c482ee019d6574b5592ac2ce5de199a08e4"
  end

  depends_on "brotli"
  depends_on "xz"

  uses_from_macos "perl"

  # Resources are for "recommends" which include the following non-core modules:
  # ├── Archive::Zip (included in macOS perl)
  # ├── Compress::Raw::Lzma
  # ├── IO::Compress::Brotli / IO::Uncompress::Brotli (patched to remove bundled brotli and Alien::cmake3)
  # │   └── File::Slurper
  # └── POSIX::strptime

  resource "Archive::Zip" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/Archive-Zip-1.68.tar.gz"
      sha256 "984e185d785baf6129c6e75f8eb44411745ac00bf6122fb1c8e822a3861ec650"
    end
  end

  resource "Compress::Raw::Lzma" do
    url "https://cpan.metacpan.org/authors/id/P/PM/PMQS/Compress-Raw-Lzma-2.225.tar.gz"
    sha256 "1292b126d831822f6b45c6c02c4fc69cc5ffbf6dc8f2515ff4f301cfcfcf684d"
  end

  resource "File::Slurper" do
    url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/File-Slurper-0.014.tar.gz"
    sha256 "d5a36487339888c3cd758e648160ee1d70eb4153cacbaff57846dbcefb344b0c"
  end

  resource "IO::Compress::Brotli" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMLEGGE/IO-Compress-Brotli-0.022.tar.gz"
    sha256 "364d2f4131548d6fac5f2df7750d0bd8ebfee10a7c28eb05e7b98ce6ac7facc1"

    # Workaround to unbundle brotli until supported upstream. All Linux distros do something similar
    # but we can't use their patches as they either are for old versions or don't work with brew brotli
    patch do
      file "Patches/exiftool/unbundle-brotli.diff"
      type :unofficial
      resolves "https://github.com/timlegge/perl-IO-Compress-Brotli/issues/5"
    end
  end

  resource "POSIX::strptime" do
    url "https://cpan.metacpan.org/authors/id/G/GO/GOZER/POSIX-strptime-0.13.tar.gz"
    sha256 "a818109829e35a4ac79677d68063865f40c87c99ca7f3a20890177a8f8e5c277"
  end

  resource "sunset-logo-jxl", :test do
    url "https://github.com/libjxl/conformance/blob/5399ecf01e50ec5230912aa2df82286dc1c379c9/testcases/sunset_logo/input.jxl?raw=true"
    sha256 "6617480923e1fdef555e165a1e7df9ca648068dd0bdbc41a22c0e4213392d834"
  end

  allow_network_access! :test

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.reject(&:test?).each do |r|
      r.stage do
        # Remove bundled brotli code
        rm_r("brotli") if r.name == "IO::Compress::Brotli"

        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "INSTALLMAN3DIR=none"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "install"

    (bin/"exiftool").write_env_script libexec/"bin/exiftool", PERL5LIB: ENV["PERL5LIB"]
    doc.install Dir["html/*"]
    man1.install_symlink libexec/"man/man1/exiftool.1"
    man3.install_symlink libexec.glob("man/man3/*.3pm")
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")

    resource("sunset-logo-jxl").stage do
      system bin/"exiftool", "-api", "Compress=1", "-Artist=homebrew", "-m", "input.jxl"
      assert_match "BrotliEXIF", shell_output("#{bin}/exiftool -verbose input.jxl")
    end
  end
end
