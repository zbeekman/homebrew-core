class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.28.8.tar.gz"
  sha256 "c14476b4d7b9a71a28e74c7c3b7b09b4a3be472de88d055de412f5744ee55d29"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6967a69f5c11ee75c7172a11a1bffa2ebf88beb594dc3db1af41a174b344f9b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6967a69f5c11ee75c7172a11a1bffa2ebf88beb594dc3db1af41a174b344f9b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6967a69f5c11ee75c7172a11a1bffa2ebf88beb594dc3db1af41a174b344f9b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "57e950372b57e2b888184eebf9f2a1584edf199a00fd3de9576d407178009a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f7cef92828a51da65ee5df878bee6672a24cdcc7ac2d9b8216b6fb5bc1bf90de"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
