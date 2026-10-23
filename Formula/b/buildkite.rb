class Buildkite < Formula
  desc "Work with Buildkite from the command-line"
  homepage "https://github.com/buildkite/cli"
  url "https://github.com/buildkite/cli/archive/refs/tags/v3.66.0.tar.gz"
  sha256 "cff14147b1ce8c02eb0c9a8663fda32b2d73b60ec6101e259eaa1a4e7187a97a"
  license "MIT"
  head "https://github.com/buildkite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db6eedc6054fa4b273a3461a8f0dd1c6656c5e580ed931c88b0039edf630d1f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db6eedc6054fa4b273a3461a8f0dd1c6656c5e580ed931c88b0039edf630d1f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db6eedc6054fa4b273a3461a8f0dd1c6656c5e580ed931c88b0039edf630d1f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "07dd53d34e772a3a500df039fc86de13ac38a564bea93b43c316f875b9492e8d"
    sha256 cellar: :any,                 x86_64_linux:      "1e8e290cdafff689f0d7695d480798300fe1bba32ae8b2cd8fc09ba61d259849"
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
