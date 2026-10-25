class Amass < Formula
  desc "In-depth attack surface mapping and asset discovery"
  homepage "https://owasp.org/www-project-amass/"
  url "https://github.com/owasp-amass/amass/archive/refs/tags/v5.1.3.tar.gz"
  sha256 "9f2023027ed418e49ff0a7d941dae050db0f73b948fefe997aef416876cfb416"
  license "Apache-2.0"
  head "https://github.com/owasp-amass/amass.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc3553b5def7a0f26408f5e37a0a404f7d7f690b6af9326fb76a5d27f5457f66"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc3553b5def7a0f26408f5e37a0a404f7d7f690b6af9326fb76a5d27f5457f66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc3553b5def7a0f26408f5e37a0a404f7d7f690b6af9326fb76a5d27f5457f66"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a9648cfc1d935237c7dfc412e05015b8796fed0c3827c1308cfe657cf81f507d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "17d753a64a442608dc274611692a4c735f9dbbfacb8205f0441abf013d9015e9"
  end

  depends_on "go" => :build

  # `test do` block performs DNS enumeration
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args, "./cmd/amass"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/amass --version 2>&1")

    (testpath/"config.yaml").write <<~YAML
      scope:
        domains:
          - example.com
    YAML

    system bin/"amass", "enum", "-list", "-config", testpath/"config.yaml"
  end
end
