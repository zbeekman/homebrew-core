class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.142.tar.gz"
  sha256 "2e8e16773b3458daee52a84b80e2edbe9dedad0b9085718f67c68ee40c2342d6"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f413a5c174b03777d432ff8138e1ae8e62714fd61bf086da4419dced0dec32e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f413a5c174b03777d432ff8138e1ae8e62714fd61bf086da4419dced0dec32e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f413a5c174b03777d432ff8138e1ae8e62714fd61bf086da4419dced0dec32e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a0b49b3a17dcc5c3774d208d3e073a801ccd377cf37af3144955eb7e2cddff6e"
    sha256 cellar: :any,                 x86_64_linux:      "918223de2bd559d1e985ebffaeb842f973fd0dfca3c895cbd08e41a7fb603544"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
