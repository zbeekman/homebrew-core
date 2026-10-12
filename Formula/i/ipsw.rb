class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.737.tar.gz"
  sha256 "51f05fac334b8435255cf0c081cb4266a2e2d941828544852f8999676f8d32de"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c0cb3f97785f0badcacd69724737b5de6ca38602523b4cb6a4642cbb97ec94d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b7646bb17ceb0835b5632849af67a7dd85381d1a3055a9cb678b921f7566ea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1adfa0473e259c8163ef4f9d64afada151e9c888961ad9926b41ba66910aa74b"
    sha256 cellar: :any,                 arm64_linux:       "8ffb485a2981d906272d28d79c4b7a500bd9eae5648c7235538b37e3f9c953ae"
    sha256 cellar: :any,                 x86_64_linux:      "23b2d5149622d5b52a28075ec9c1a27923e2acd6d12d07c8876a025188d49fe2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
