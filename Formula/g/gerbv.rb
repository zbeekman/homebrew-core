class Gerbv < Formula
  desc "Gerber (RS-274X) viewer"
  homepage "https://gerbv.github.io/"
  url "https://github.com/gerbv/gerbv/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "0479b333efffadc118b7e3080be5621d8890fdcd2376edbe40a686d5c3642784"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "bd3faae6ce425d75f21c4dc96e4c4c7a30d708f24aed8fa77d0749f3f3f241b4"
    sha256 arm64_tahoe:       "bf6c87fbaf8c1ba9224b0114f8274c5428b8dd4f5a9c9fda72609f6241466bc1"
    sha256 arm64_sequoia:     "d13b732f78eed944284e3095d8c901212ff01398e2ca3396541725080054b19d"
    sha256 arm64_sonoma:      "fb5a4094a415b80d3c321942fbaefff760ad3bf5ccb6ed1094d0ec40be460e32"
    sha256 arm64_linux:       "a5a419bcdedf5f24b132a6d8b5208c7c50c7be99ea4a402805bcc8b15074e589"
    sha256 x86_64_linux:      "d8b160c89e1f26c9259b1ea83ec5ac0e09ed317b9ccae0e1715d8b4c7e3409cd"
  end

  # Can be undeprecated if upstream moves to GTK 3/4: https://github.com/gerbv/gerbv/issues/71
  deprecate! date: "2026-08-28", because: "needs EOL `gtk+`"
  disable! date: "2027-08-28", because: "needs EOL `gtk+`"

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+" # GTK3/GTK4 issue: https://github.com/gerbv/gerbv/issues/71

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  deny_network_access!

  def install
    args = %w[--toolchain cmake/toolchains/macos-clang.cmake] if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # executable (GUI) test
    system bin/"gerbv", "--version"
    # API test
    (testpath/"test.c").write <<~C
      #include <gerbv.h>

      int main(int argc, char *argv[]) {
        double d = gerbv_get_tool_diameter(2);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libgerbv").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags, "-Wl,-rpath,#{lib}"
    system "./test"
  end
end
