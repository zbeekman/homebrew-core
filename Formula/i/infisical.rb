class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.44.5.tar.gz"
  sha256 "b88aaf8e3554bf36360914234827d9e83c9d9bcec65cb8b16534f55327766a45"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e40fd7c756f109f29c492031148148f6670c270477b87e89350e6d8fb2fd013"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4e40fd7c756f109f29c492031148148f6670c270477b87e89350e6d8fb2fd013"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4e40fd7c756f109f29c492031148148f6670c270477b87e89350e6d8fb2fd013"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c8afdb7f5015e6eb5fbae7f2260058b215a17c23cddda96345ca07183145bc98"
    sha256 cellar: :any,                 x86_64_linux:      "eca20c672c1653f7367ebebda14226ce1da3530bad7bab8d3655570d8fe740ca"
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
