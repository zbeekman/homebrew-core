class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.20.0",
      revision: "fa59e56f7eef9dd9b9e920cee44ce4f6bfa7f064"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b77241c06dd7b48e9dd895b0aca0e3f6ce3cca54c296973bf7a66714c22fdda"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b77241c06dd7b48e9dd895b0aca0e3f6ce3cca54c296973bf7a66714c22fdda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b77241c06dd7b48e9dd895b0aca0e3f6ce3cca54c296973bf7a66714c22fdda"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c3bb53615ed0d170c59f34922b963bb270ddcc0bafceea91383c63b68372b10c"
    sha256 cellar: :any,                 x86_64_linux:      "bdbbcdcf8e7e76cdf6fe0eff7f5e469b98d127de681b13f02cb52d6906046671"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/lacework/go-sdk/v2/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/v2/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/v2/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/v2/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
