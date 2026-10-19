class S6Rc < Formula
  desc "Process supervision suite"
  homepage "https://skarnet.org/software/s6-rc/"
  url "https://skarnet.org/software/s6-rc/s6-rc-0.8.0.1.tar.gz"
  sha256 "e647a2b828d6aceb68024889a29f6406aaefc85b1853332e0f3982eb5670b331"
  license "ISC"
  head "git://git.skarnet.org/s6-rc.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "a578d8182358720c883a725855f3fc41973caa74c5881250b226735e8e0ce389"
    sha256 arm64_tahoe:       "970b7178c1205d1ad24a99c054b6782f09f78fb662ad9d522587ab9d0e2c0bfd"
    sha256 arm64_sequoia:     "7574bcadb388c927b6f1992414eb0e138334c21d3e24cd0c9d4e1c00a549422d"
    sha256 arm64_linux:       "a806a2642da994b7792d581dd73a2924442d9fbc4327afe87472d70b5a5e027d"
    sha256 x86_64_linux:      "04fcd61328bbd5b00dd096cca856a280b19ff4a6c9c4e6c77924c1f68ddd33c4"
  end

  depends_on "pkgconf" => :build
  depends_on "execline"
  depends_on "s6"
  depends_on "skalibs"

  def install
    # Shared libraries are linux targets and not supported on macOS.
    args = %W[
      --disable-silent-rules
      --disable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{formula_opt_bin("pkgconf")}/pkg-config
      --with-sysdeps=#{formula_opt_lib("skalibs")}/skalibs/sysdeps
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"services/test").mkpath
    (testpath/"services/test/up").write <<~SHELL
      #!/bin/sh
      echo "test"
    SHELL
    (testpath/"services/test/type").write "oneshot"
    (testpath/"services/bundle/contents.d").mkpath
    (testpath/"services/bundle/type").write "bundle"
    touch testpath/"services/bundle/contents.d/test"
    system bin/"s6-rc-compile", testpath/"compiled", testpath/"services"
  end
end
