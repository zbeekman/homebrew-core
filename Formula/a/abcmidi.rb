class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/"
  url "https://ifdo.ca/~seymour/runabc/abcMidi-2026.10.16.zip"
  sha256 "f865e7a0107f30b0b6fa005c063c14e7c830f81cd626d872ec9788a912488048"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd7f8d672df7467b714a338e33bee02b8672ab93a5fa7fec496e2c8a15e83f36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "86749a5a4c79becbee4804bc41318352f5d5e22c0891a62ed850041453a60722"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f10831d262cc38cdc705f6d9ffed1b0b48be94281d89daca214b0eab8145314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1a7680bfd65269ed9c71517d8a9be0dbb3cb82148152da38d98cf9dd81ffe3ce"
    sha256 cellar: :any_skip_relocation, sonoma:            "cdc40e360405b88af8f4b7323b5002c11e8facabf6e29d907baa347a14518de7"
    sha256 cellar: :any,                 arm64_linux:       "21e2b48aff01d92d055bc4962ee83a76b52b84160d68195f9425935f9a739dcf"
    sha256 cellar: :any,                 x86_64_linux:      "469d41a626fbf6344c0d137ab4056117f490737f77527b3a3e82391f4a4160f3"
  end

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"balk.abc").write <<~EOS
      X: 1
      T: Abdala
      F: https://www.youtube.com/watch?v=YMf8yXaQDiQ
      L: 1/8
      M: 2/4
      K:Cm
      Q:1/4=180
      %%MIDI bassprog 32 % 32 Acoustic Bass
      %%MIDI program 23 % 23 Tango Accordion
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOS

    system bin/"abc2midi", testpath/"balk.abc"
  end
end
