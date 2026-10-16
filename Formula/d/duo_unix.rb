class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/refs/tags/duo_unix-2.3.0.tar.gz"
  sha256 "f8c53a1beb54f40765c1f5708a6cf6fd4abd94c645d5fdc52e222223d2040092"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256               arm64_golden_gate: "1ae6947bff0f587bccca6dd218025a6439330db6347163ec23f0a352a5eaaa3e"
    sha256               arm64_tahoe:       "86169dd876ceaecbc9cb6a5ac9129d1017d4f4deae25a201ab9079644a927241"
    sha256               arm64_sequoia:     "c7a6bfaaf569b5f61b2a175dccf75b0648d1acba0abd7bbcdd4dafc718c032c5"
    sha256               arm64_sonoma:      "49d5e1bb8dc291e0715a70720f414c8960328e4fbe5c09392e3b053ffcfb8724"
    sha256 cellar: :any, sonoma:            "f67e032b567f5adf158d6de0679b6b7fa379ed16a53400cdf3e0c43d7b5f650a"
    sha256               arm64_linux:       "9f1355e86e849a120c9c674569b33ea9b2a85fcbd104acbc139f6ed9270a703a"
    sha256               x86_64_linux:      "6d90ecc722c702a3b19a78fc7e80cc06803322cf8ab46878132609bce644c185"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "linux-pam"
  end

  # Apply open PR to support OpenSSL 4
  patch do
    url "https://github.com/duosecurity/duo_unix/commit/c17f4845ca553a6cd33f6554aabcf7e726fc167b.patch?full_index=1"
    sha256 "7f1692ba71faddd872b034cce36804f70f5d23a53462dcf4a08f9d0a7ee1293b"
    type :unofficial
    resolves "https://github.com/duosecurity/duo_unix/pull/410"
  end

  deny_network_access!

  def install
    # Darwin declares `strftime_l` in <xlocale.h> rather than <time.h>
    ENV.append_to_cflags "-include xlocale.h" if OS.mac?

    File.write("build-date", time.to_i)
    system "./bootstrap"
    system "./configure", "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{formula_opt_prefix("openssl@4")}",
                          "--with-pam=#{lib}/pam/",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                             "-f", "foobar", "echo", "SUCCESS"
  end
end
