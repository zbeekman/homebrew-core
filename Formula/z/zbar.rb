class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://linuxtv.org/downloads/zbar/"
  url "https://linuxtv.org/downloads/zbar/zbar-0.23.95.tar.gz"
  sha256 "7b0907a3114503e0a8fbd1c6bfdb61592e6ded79f68716d7ca673ddeb6a87e99"
  license "LGPL-2.1-only"
  head "https://github.com/mchehab/zbar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?zbar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "3f0948f78c993d1315173d6cb2c764011a1be3d272b3bae0aa56946e68171647"
    sha256 arm64_tahoe:       "b4deb14c35eead04e9aba7f9f8bf990e8adb3987efd2f721c8a600bcb8c91ba1"
    sha256 arm64_sequoia:     "1dc038ef320116fc0189292e46e6b1849df3caf33c45e53e2861a804c9a8986f"
    sha256 arm64_sonoma:      "427a79a4f97bdf6e67de3feb529981a962e26b11003ddcc8ee7b4b0fd530d52b"
    sha256 sonoma:            "69272a54a24e5899c18a2f1eb6d631528fcc12ffe29f0170d8d9b984aa7f6f81"
    sha256 arm64_linux:       "0f702ac6c4a6c3fce3fc6cfaa596b7d80b7858dce5e67e7a39205c893f2bf09e"
    sha256 x86_64_linux:      "9bd3a7733de4b5c4b15d7a1b8de0450a2176bcea9b995a0203f31cb8d5d3b722"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build

  depends_on "imagemagick"
  depends_on "jpeg-turbo"

  uses_from_macos "python"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "glib"
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "libtool"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "dbus"
  end

  deny_network_access!

  def install
    args = %w[
      -Dvideo=false
      -Djava=disabled
      -Dqt=false
      -Dgtk=no
      -Dx11=disabled
    ]

    # zbar uses gettext but upstream only links libintl on Windows, and the
    # newer macOS linker no longer resolves it transitively. Link it explicitly.
    ENV.append "LDFLAGS", "-lintl" if OS.mac?

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    pkgshare.install "examples/qr-code.png"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zbarimg --version")

    output = shell_output("#{bin}/zbarimg -1 #{pkgshare}/qr-code.png 2>/dev/null")
    assert_match "QR-Code:https://github.com/mchehab/zbar", output
  end
end
