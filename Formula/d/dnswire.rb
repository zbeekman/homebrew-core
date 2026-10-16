class Dnswire < Formula
  desc "Library for encoding/decoding different DNS encapsulations"
  homepage "https://codeberg.org/DNS-OARC/dnswire"
  url "https://www.dns-oarc.net/files/dnswire/dnswire-0.5.0.tar.gz"
  sha256 "7db89f8118ea42b116fc211b05bc4253d105c86054c2dbce58f8ead80c8f3aad"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "03b6487836219f1bf82139fa6af2da694ffd68eefca34f3bd661ef101df5d2e2"
    sha256 cellar: :any, arm64_tahoe:       "dfb4a22cc0a71bede61113e5121e3b9c3739a71cd07ce2fd33e64b521d614490"
    sha256 cellar: :any, arm64_sequoia:     "0663fd5e98a0aaf43ac0652d8a349450a9b098aa9c7d51293b6bc948527cf995"
    sha256 cellar: :any, arm64_linux:       "86bdc8eff29077180c26e1142aa5aa9f739b452e5629bb3d39557ca2b601f34e"
    sha256 cellar: :any, x86_64_linux:      "57efa8750005d4f7d29483849902d5393f0b143368f0a69e3935bc9acbb61010"
  end

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
