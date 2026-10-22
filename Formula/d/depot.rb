class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.103.0.tar.gz"
  sha256 "35d5fc895a7cf6d63bc3dbb9e58d05d15695e05d9b0e5bd8c32d7dace0c9175f"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d425b4a892f806fe376663e1b523db67d451cdd5245820d277660adfbcabb05d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d425b4a892f806fe376663e1b523db67d451cdd5245820d277660adfbcabb05d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d425b4a892f806fe376663e1b523db67d451cdd5245820d277660adfbcabb05d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "831c6ff5d4efc81ed4b651936f156f8c8543a806ff2bd11c6007f2ea4e8ab8b9"
    sha256 cellar: :any,                 x86_64_linux:      "91adcf4bda203e886f80133d548d7ff9e3210bf47b6c1794a5ffbc3054d442a0"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "unknown project ID", output
  end
end
