class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.145.tar.gz"
  sha256 "0b4cb6c2cec6c72467c67b263fd15a6ad430d9c1d845f028560aa62d7648958d"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e68a945c42740f38a5628ae2f290c9f4fbb0369ed358b18225e505cdbd0b80e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e68a945c42740f38a5628ae2f290c9f4fbb0369ed358b18225e505cdbd0b80e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e68a945c42740f38a5628ae2f290c9f4fbb0369ed358b18225e505cdbd0b80e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "501f838f9f74b25f6d8ef1a57910e2a8e28422acfafa3d6e055f27e218420656"
    sha256 cellar: :any,                 x86_64_linux:      "5b00300b5dd751060aeb868795b8c928f1bdedc4db7e43b373215c7d87e347d9"
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
