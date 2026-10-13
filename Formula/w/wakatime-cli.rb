class WakatimeCli < Formula
  desc "Command-line interface to the WakaTime api"
  homepage "https://wakatime.com/"
  url "https://github.com/wakatime/wakatime-cli.git",
      tag:      "v2.27.3",
      revision: "d64b143a06e6e61a9df39ede798d579a55ab4bbc"
  license "BSD-3-Clause"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "043f6125a5131c944ed3b106414bb718fb8474f075721c96bca6d0cae5b6bf7a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "043f6125a5131c944ed3b106414bb718fb8474f075721c96bca6d0cae5b6bf7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "043f6125a5131c944ed3b106414bb718fb8474f075721c96bca6d0cae5b6bf7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c14112465e15250ba4ad3e3bd26423a8809f5a5ad5243ed1474475554acab58"
    sha256 cellar: :any,                 x86_64_linux:      "9c32e38497a3f36f9bc077a3c36191f692a27ea929f3ce5c31ed10d69cf5139d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    ldflags = %W[
      -X github.com/wakatime/wakatime-cli/pkg/version.Arch=#{arch}
      -X github.com/wakatime/wakatime-cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/wakatime/wakatime-cli/pkg/version.Commit=#{Utils.git_head(length: 7)}
      -X github.com/wakatime/wakatime-cli/pkg/version.OS=#{OS.kernel_name.downcase}
      -X github.com/wakatime/wakatime-cli/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"wakatime-cli", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/wakatime-cli --help 2>&1")
    assert_match "Command line interface used by all WakaTime text editor plugins", output
  end
end
