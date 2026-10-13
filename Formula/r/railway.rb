class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.67.1.tar.gz"
  sha256 "90fd5260e975ee94b9680f2c54322438e4df01ea261a033fee514aa2bd208ac3"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ec5ed96a8f69e1427e113915620b7591412d60801984865540d8ebcec668b17"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cde374107876cf32e465613b7afcd24c95baf4c4ded58eb5e72b7df76de382f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7d8db14e4e6248b876689c1f679ec77b9457d0b201aee07904449224d02a1ea8"
    sha256 cellar: :any,                 arm64_linux:       "d54e03b7dafc5e2002c5b7084eb94b5f05cd4a0013eabff532fa326287a31c45"
    sha256 cellar: :any,                 x86_64_linux:      "6d7d9afee03a3a87a114833a230192cfea38de927f93c86152c10211d421dfb0"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
