class Swctl < Formula
  desc "Apache SkyWalking CLI (Command-line Interface)"
  homepage "https://skywalking.apache.org/"
  url "https://github.com/apache/skywalking-cli/archive/refs/tags/0.15.0.tar.gz"
  sha256 "2b167a3f32939a6fa03363720e94d5c44e2e66563a5991627b109a2377883c7d"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-cli.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b7835ef079a6d0785fb7bf85a38d00845016c9f59deab1868e330d8ecd0231eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9af57f6ad01333ac24e4ecc421eba5ee201f7a5302d56f501bb8e1494ac4e24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9af57f6ad01333ac24e4ecc421eba5ee201f7a5302d56f501bb8e1494ac4e24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b9af57f6ad01333ac24e4ecc421eba5ee201f7a5302d56f501bb8e1494ac4e24"
    sha256 cellar: :any_skip_relocation, sonoma:            "624acdc72d44849936d334739c194c880319524091aeea753662f7445a63ff3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "30df7166e091ecdd5e6cf92cd2d73d98eae728ec58e23ce7ccfd4f0ca231c29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9005d0b0a2edd4d0661257b07d1d9ef0b5328718e0f2ca7caedaae48025df560"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/swctl"

    generate_completions_from_executable(bin/"swctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/swctl --version 2>&1")

    output = shell_output("#{bin}/swctl --display yaml service ls 2>&1", 1)
    assert_match "level=fatal msg=\"Post \\\"http://127.0.0.1:12800/graphql\\\"", output
  end
end
