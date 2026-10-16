class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.44.2.tar.gz"
  sha256 "984c2946c8cdeddc6725958f49931d05161363f3d64afd9064437513da855a6b"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c955f6bd1106f9ada596ab7557070abebb0acca1407f4270b99ba2cc122be34a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c955f6bd1106f9ada596ab7557070abebb0acca1407f4270b99ba2cc122be34a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c955f6bd1106f9ada596ab7557070abebb0acca1407f4270b99ba2cc122be34a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fae67bd5e9297fdea8e3d9c7ac29a8a1e8a7f129607c02836b2facdc7282f4c6"
    sha256 cellar: :any,                 x86_64_linux:      "9b1ec3eb72220d585dc7ca997ef3867f1cee884d0bb866e4bac9e6090c636c52"
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
