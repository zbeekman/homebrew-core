class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://rbenv.org/man/ruby-build.1"
  url "https://github.com/rbenv/ruby-build/archive/refs/tags/v20261023.tar.gz"
  sha256 "3f083e548366544de28814c58954c6d31f05d115dce20fb01fff1c0069f03549"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "358e0a9c5b47dfe7cff90805b62a0e87b320a7357ff0d095b9eab1813703635c"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "openssl@4"
  depends_on "pkgconf"
  depends_on "readline"

  deny_network_access!

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ruby-build --version")

    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
