class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://rbenv.org/man/ruby-build.1"
  url "https://github.com/rbenv/ruby-build/archive/refs/tags/v20261023.tar.gz"
  sha256 "3f083e548366544de28814c58954c6d31f05d115dce20fb01fff1c0069f03549"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f6bc66ac72d1e457af8be974a0f9e54f6c2309b608f892adcde8326cfd65859f"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "openssl@3" # TODO: OpenSSL 4 needs https://github.com/rbenv/ruby-build/pull/2647
  depends_on "pkgconf"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
