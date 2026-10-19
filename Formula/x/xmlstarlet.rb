class Xmlstarlet < Formula
  desc "XML command-line utilities"
  homepage "https://xmlstarlet.github.io/"
  url "https://github.com/xmlstarlet/xmlstarlet/releases/download/1.7.0/xmlstarlet-1.7.0.tar.gz"
  sha256 "df4c93458fc6b2ad144d65dccf3ef251349871e0578c5bc59edbfeecf9bf3454"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6af95d7b6c54dd220507cd7e41ad8d3eacff224a31ce4638a5005789a0cf21ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a8da4979558af0c5679c2cadfac4c5a0a9f851eccd6a3ef74e0475b1dae7edfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0c422e59ff501221aafa5679bcb5c83703f54c83768c0a144fc80d997b1961d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "355f3500eef2193e7a18e4fa465dda10c686690cb3118d60c644b2f09e9076f7"
    sha256 cellar: :any_skip_relocation, sonoma:            "80f27cfee431b938bb3e4fadd7fc1a8dbe740ce1b00a053e6bee64441f7e5e23"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "04a42fc41c21c9c4fb1483128c6a6be0ffe23ac31f181904aeb68cd12fe4dc8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e5a94dccc66555dee58f477b358e98d91f5b9afff2c4385471ab19fb57c42e32"
  end

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    bin.install_symlink "xml" => "xmlstarlet"
  end

  test do
    system bin/"xmlstarlet", "--version"
  end
end
