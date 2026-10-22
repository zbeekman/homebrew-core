class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v7.3/strace-7.3.tar.xz"
  sha256 "529634c40910895a9a1f3c5c1e65da2ca9ed72fb158dfc4bcc89efdf05e39b72"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_linux:  "c34922f79345da9ba1775939017ab18c8a3ee9ae15fee938f8c097674b586bcb"
    sha256 cellar: :any, x86_64_linux: "a22cb25f2744e08e04c4bb5ed6176a13b05cf038bca608e46c73927c2edf0d22"
  end

  head do
    url "https://github.com/strace/strace.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :linux

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--enable-mpers=no", # FIX: configure: error: Cannot enable m32 personality support
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    out = `"strace" "true" 2>&1` # strace the true command, redirect stderr to output
    assert_match "execve(", out
    assert_match "+++ exited with 0 +++", out
  end
end
