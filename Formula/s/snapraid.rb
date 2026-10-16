class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v15.0/snapraid-15.0.tar.gz"
  sha256 "ceba44e15566386d923d6895ecab81f7437848b03a4cf9585c02d3636197ce19"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60a8abfe912612860e0dee9e3ff2392cb12df382c7ef286c3b764e52ce76e38f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7722c0404f551c9fa82541bd8c795f4e82852e7f14de7ee47dd0fa920e9e1dbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca35aa51cc64eae032771332f555068e577f7c48af92f38fac4f6a87c562b5fa"
    sha256 cellar: :any,                 arm64_linux:       "947e0438a74942f743c373b967c8647148e4ca8817512e09a5f1ecd9e8e00051"
    sha256 cellar: :any,                 x86_64_linux:      "b49b5098ebbb54d6d8f9f23f6168e8f1c06082ffaa1ebe3d709dc4e9f7a79103"
  end

  head do
    url "https://github.com/amadvance/snapraid.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
