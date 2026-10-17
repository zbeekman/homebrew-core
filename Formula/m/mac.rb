class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1330_SDK.zip"
  version "13.30"
  sha256 "9f74ffc0300d0b664e0530186d543e060f50e8776ae9325ec7b3f8fb1eb3f230"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "06997f7860887075be3c30e5351cba32f86958394ab0d39d05fa335b294fe515"
    sha256 cellar: :any, arm64_tahoe:       "be28a2fce1d66d70d4ed07ed9642fe6fa8da4b4b160f7e3595ed0d62c61a3734"
    sha256 cellar: :any, arm64_sequoia:     "51d197562995f80efedf04ff2eef95c03efb54bcb0142db5a7f984945aef99d2"
    sha256 cellar: :any, arm64_linux:       "e9f76edcd510bb77fdf329bb91c530d25d370cf675a29ab209d27a1c786c36a8"
    sha256 cellar: :any, x86_64_linux:      "6d2015eeac1d384644e7fc0366e9584bd7e1b101bcc7709f537804fd3facfdd1"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mac", test_fixtures("test.wav"), "test.ape", "-c2000"
    system bin/"mac", "test.ape", "-V"
    system bin/"mac", "test.ape", "test.wav", "-d"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.wav").read),
                 Digest::SHA256.hexdigest((testpath/"test.wav").read)
  end
end
