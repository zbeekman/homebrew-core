class Buildkite < Formula
  desc "Work with Buildkite from the command-line"
  homepage "https://github.com/buildkite/cli"
  url "https://github.com/buildkite/cli/archive/refs/tags/v3.65.0.tar.gz"
  sha256 "df4b7cf62080f240834d4243cfc09c8f638c00da658527f7053c61bb487491b2"
  license "MIT"
  head "https://github.com/buildkite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e8623babbc15b4db062e1b4e47b7970523b984156ced48237dcb05a0696de398"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e8623babbc15b4db062e1b4e47b7970523b984156ced48237dcb05a0696de398"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e8623babbc15b4db062e1b4e47b7970523b984156ced48237dcb05a0696de398"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "778068eb50961e24f885748e7189ce2273a90b4856b3342620d45b91c05345d4"
    sha256 cellar: :any,                 x86_64_linux:      "7e3b395b814919c154bd71fbcb5c1fe0394e73824962fc2c912ca6926df69c35"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/buildkite/cli/v3/cmd/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buildkite --version")

    system bin/"buildkite", "config", "set", "output_format", "yaml", "--local"
    assert_equal "yaml", shell_output("#{bin}/buildkite config get output_format").strip
  end
end
