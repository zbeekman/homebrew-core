class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/cli/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "2747957ca6a3b923b49a9440f4f18fa337ee445ede4d359b606e22c1cba3641e"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "27cb2b250639915b9bf22847af49fab2ac12014969a3ecf1c2c64bd53f2df1fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27cb2b250639915b9bf22847af49fab2ac12014969a3ecf1c2c64bd53f2df1fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27cb2b250639915b9bf22847af49fab2ac12014969a3ecf1c2c64bd53f2df1fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3b77be93bba64d755b548c72b4271222ba3969206a544585466cd3a5deb4c7e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b40c2f8feaa6ab1fcbe725762063664c956b7dfb0a38300efabba367aa1eb88d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/cli/version.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"infracost", ldflags:), "main.go"

    generate_completions_from_executable(bin/"infracost", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    ENV["INFRACOST_CLI_AUTHENTICATION_TOKEN"] = "dummy"
    output = shell_output("#{bin}/infracost setup --no-color 2>&1", 1)
    assert_match "setup requires interactive login", output
  end
end
