class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.67.1.tar.gz"
  sha256 "90fd5260e975ee94b9680f2c54322438e4df01ea261a033fee514aa2bd208ac3"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52792cad42c6f15529394f83bebc1d49985e5f3047f884d346bebe5b7584f838"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da53e5393326a58aabaf216c076dd6000f778d80880975d4b3adfc1f18cb212a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11f19123fa5ba5bc69e08d3dd94bac6b1b504bd15017af342b12c8390ea5054f"
    sha256 cellar: :any,                 arm64_linux:       "a4da24ae92e8ffdb7ee6ebd6061ac7be70d9170541eca5a4010aaf71e3d87a4b"
    sha256 cellar: :any,                 x86_64_linux:      "66571351d8c4878fc16311a698fc46f6fd55864b7004914224063e83908983e9"
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
