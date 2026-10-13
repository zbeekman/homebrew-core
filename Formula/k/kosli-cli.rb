class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.47.1.tar.gz"
  sha256 "4478be52d1763132d1250e08e65df1419897d0521b9ecfc54994ec36af4a5f42"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "580b4a63cdba5e7943aa7e94a028786e5c63dfbc5b5a432c09c8ee0e6613ac61"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d04d2131325bf715fd74a0d43fa4da7b9e9c631cb69ec12920a1995410993e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82328e3755d940a41af93acfb030ea3adb34eed88d7416f9a2196a071c9690df"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a5033845baf597b640e2c73dde343d6f1ff4aebc73a82dca0f6d342d4993bf2f"
    sha256 cellar: :any,                 x86_64_linux:      "ebdfbac8b2565906c1e89fb02ae6f8f29f3449cca0bfeb102a80f881dd6bb13d"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
