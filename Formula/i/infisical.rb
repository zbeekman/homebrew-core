class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.44.3.tar.gz"
  sha256 "b959eb188361ac635ce8645864d5c9393ae3f708d42dbb44081c7916c77e935e"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eb4bd34421ef29f831c8fe752a5ec5c2b0ebc2bf012450b492f9792e7e9c01ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb4bd34421ef29f831c8fe752a5ec5c2b0ebc2bf012450b492f9792e7e9c01ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb4bd34421ef29f831c8fe752a5ec5c2b0ebc2bf012450b492f9792e7e9c01ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b37386b30b01c8e3ef280586d8704ed10107767bc72d8c362f93fae3412d78f8"
    sha256 cellar: :any,                 x86_64_linux:      "829ad4b3a64c6e4963a42aa2903dc457277033da198691335a33731d6c7a7dbb"
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
