class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://github.com/grafana/gcx/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "91c3083d645224ff156e00d12a58f021b5b009db2f9f9499a150979b159c45c0"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c441ad7a40c2281f3f32618921c3d948903406a7de08ffd380d72fefdd6361f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70f79c00db53e4377ca24d537e2b7bae14d50c2e61fb40c15dd3757a1c3f19b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "775700956b500c6bf40efeab1464e4ed44dd201fe486af30c1276f4e10cb4772"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c02b50dd3a90953709473a37230e7edc653cd5d0bf0cf1b0a2b16eb48d1656a4"
    sha256 cellar: :any,                 x86_64_linux:      "a04d46d9f6768143050c6e5f9b48ae5e7a8526b4d73b05c4fb7356d6b32d344f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/gcx"

    generate_completions_from_executable(bin/"gcx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gcx --version")

    system bin/"gcx", "config", "set", "stacks.test.grafana.server", "https://grafana.example.net"
    assert_match "https://grafana.example.net", shell_output("#{bin}/gcx config view")

    assert_match "unknown output format", shell_output("#{bin}/gcx commands --output bogus 2>&1", 1)
  end
end
