class Dislocker < Formula
  desc "FUSE driver to read/write Windows' BitLocker-ed volumes"
  homepage "https://github.com/Aorimn/dislocker"
  url "https://github.com/Aorimn/dislocker/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "c39261727a4993af13f90beec5ce1b56932f8a6d813df26e437ed0a668cf4141"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_linux:  "6fc800d70967d83257c8716d1a802960c44a892f7a3594db882737cceebeb5c3"
    sha256 cellar: :any, x86_64_linux: "5656ee57b450b544d660941fa9682cc999dcde547cd4b3911f5f5660c82a4b71"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@4"

  deny_network_access!

  def install
    args = %w[
      -DCRYPTO_BACKEND=openssl
      -DWITH_RUBY=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dislocker", "-h"
  end
end
