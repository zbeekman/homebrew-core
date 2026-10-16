class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://github.com/walles/moor/archive/refs/tags/v2.19.5.tar.gz"
  sha256 "1ac816a00e30d601da064176cca6537cb3102132111e247abf24573eff8d4030"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08a463e950c5d5b019a44e33839d084941492dff993e6f6f63f2e06433566762"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08a463e950c5d5b019a44e33839d084941492dff993e6f6f63f2e06433566762"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08a463e950c5d5b019a44e33839d084941492dff993e6f6f63f2e06433566762"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e158cf2395360538d01f007fb0eba24edf1aca17a87f06b61c323e5513183fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "390cc1b9e17ec130f45f5022f351c5c75700a1efd2ed91c7a5e1aac129bca2c0"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/moor"

    # Hint for moar users to start typing "moor" instead
    bin.install "scripts/moar"

    man1.install "moor.1"
  end

  test do
    # Test piping text through moor
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moor test.txt").strip
  end
end
