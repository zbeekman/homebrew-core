class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261014-git-12390db.tar.gz"
  version "0.3a-20261014-git-12390db"
  sha256 "bd8cc56715804e50751f24e2da0ec7d370189a285b22c48fb32d87cb28e2694d"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a169fa5298d6c46ea67d708cabe4aec9992ebcf027996ac7c9bece84498e4b02"
    sha256 cellar: :any, arm64_tahoe:       "b79de42649f2eeb5bd4666c17f30976dd963b75852498cf474aef7a954c61516"
    sha256 cellar: :any, arm64_sequoia:     "f01de56e138fc9914e8f75c1cbe613c33a9e13e591880e9e46fab2286b3163d8"
    sha256 cellar: :any, arm64_linux:       "03adb5090a70a8289f98c12e9c5cb92fe8a391bc316e69a271b9678b3f5e715b"
    sha256 cellar: :any, x86_64_linux:      "cc5ac05be012c22ca5a1b29285fad5aa89fccea65116a7ee1fce15179fbb5e8b"
  end

  depends_on "sdl2-compat"
  depends_on "sdl2_net"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Not using Makefile.OSX as it uses prebuilt frameworks
    system "make", "-f", "Makefiles/Makefile.UNIX", "BIN_DIR=#{bin}"
  end

  test do
    system bin/"supermodel", "-print-games"
  end
end
