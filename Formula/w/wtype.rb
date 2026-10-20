class Wtype < Formula
  desc "Xdotool type for wayland"
  homepage "https://github.com/atx/wtype"
  url "https://github.com/atx/wtype/archive/refs/tags/v0.5.tar.gz"
  sha256 "684308ac8b47c510dddf4abac3aef86b4f7b8c0e165389a40608679a7a5b77ed"
  license "MIT"

  bottle do
    sha256 arm64_linux:  "67c56b2dd69bc9e41cb2f1d31fae8421bf589e1c094cc16bd975dc743fc61c00"
    sha256 x86_64_linux: "fb8b560329a38b9ffce961dbedbbfa9cd687d6e07f104604754da4328035ed11"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libxkbcommon"
  depends_on :linux
  depends_on "wayland"
  depends_on "wayland-protocols"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Wayland connection failed", shell_output("#{bin}/wtype test 2>&1", 1)
  end
end
