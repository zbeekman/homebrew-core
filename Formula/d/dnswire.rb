class Dnswire < Formula
  desc "Library for encoding/decoding different DNS encapsulations"
  homepage "https://codeberg.org/DNS-OARC/dnswire"
  url "https://www.dns-oarc.net/files/dnswire/dnswire-0.5.0.tar.gz"
  sha256 "7db89f8118ea42b116fc211b05bc4253d105c86054c2dbce58f8ead80c8f3aad"
  license "GPL-3.0-or-later"

  depends_on "pkgconf" => [:build, :test]
  depends_on "libuv"
  depends_on "protobuf-c"
  depends_on "tinyframe"

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dnswire/version.h>
      #include <stdio.h>

      int main(int argc, char *argv[]) {
        printf("Version %s", DNSWIRE_VERSION_STRING);
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs libdnswire").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_match version.to_s, shell_output("./test")
  end
end
