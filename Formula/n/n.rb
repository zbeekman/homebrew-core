class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "44e0bfd66aadff042817d1da90adaf5dfd16d269aefb4f0c79b5a4da23bd0abd"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3c9c7f8da6a1a735450f6e1b7a49483aa878ef6dc4657e68f4d3bb238cade1c2"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
