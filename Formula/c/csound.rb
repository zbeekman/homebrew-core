class Csound < Formula
  desc "Sound and music computing system"
  homepage "https://csound.com"
  url "https://github.com/csound/csound.git",
      tag:      "7.0.0",
      revision: "c58f4de6b8056b9356f31615b395b3bfd9bd0775"
  license "LGPL-2.1-or-later"
  head "https://github.com/csound/csound.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "cb405dbf38d9291281c13a38aebc1351a51e3b2fcbcfd7d552ac0ef9213f8065"
    sha256 arm64_tahoe:       "9caad7f594d564dc2a6c68cf9ce8cdfd18eccbfbdb2069f5d87831796faeb486"
    sha256 arm64_sequoia:     "8a6541812e99b3920f402625bcd0b90ef9c949b882f771563e38e5122a919f11"
    sha256 arm64_linux:       "5a19e2217e2a0e4b0a09e27e9828efdca31ae2c67dfed1c18a166520a23d7ab6"
    sha256 x86_64_linux:      "3edd6181b8d2edfa0188223692fafb99a2e9e19dacfdecaaf3948c633db4ddc5"
  end

  depends_on "asio" => :build
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "jack"
  depends_on "lame"
  depends_on "liblo"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "python@3.15"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "pipewire"
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "libextractor", because: "both install `extract` binaries"

  def install
    rpaths = [rpath]
    rpaths << rpath(target: frameworks) if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    "-DBISON_EXECUTABLE=#{formula_opt_bin("bison")}/bison",
                    "-DBUILD_TESTS=OFF",
                    "-DCS_FRAMEWORK_DEST=#{frameworks}",
                    "-DINSTALL_PYTHON_INTERFACE=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      include.install_symlink frameworks/"CsoundLib64.framework/Headers" => "csound"
    else
      # On Linux, csound depends on binutils, but both formulae install `srconv` binaries
      (bin/"srconv").unlink
    end
  end

  def caveats
    on_linux do
      <<~EOS
        srconv is not installed because it conflicts with binutils. To run srconv:
          csound --utility=srconv
      EOS
    end
  end

  test do
    (testpath/"test.orc").write <<~ORC
      0dbfs = 1
      instr 1
          out oscils(0.5 * 0dbfs, 440, 0)
      endin
    ORC

    (testpath/"test.sco").write <<~SCO
      i 1 0 1
      e
    SCO

    if OS.mac?
      ENV["OPCODE6DIR64"] = frameworks/"CsoundLib64.framework/Resources/Opcodes64"
      ENV["SADIR"] = frameworks/"CsoundLib64.framework/Versions/Current/samples"
    else
      ENV["OPCODE6DIR64"] = lib/"csound/plugins64-6.0"
      ENV["SADIR"] = share/"samples"
    end

    system bin/"csound", "test.orc", "test.sco"

    assert_path_exists testpath/"test.#{OS.mac? ? "aif" : "wav"}"
  end
end
