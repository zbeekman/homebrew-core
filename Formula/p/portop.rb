class Portop < Formula
  desc "Terminal UI showing which processes are using TCP and UDP ports"
  homepage "https://github.com/padovanl/portop"
  url "https://github.com/padovanl/portop/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e84d56316ae48ebef064d1f8e995885e93ecd2d4d3abb3ba0e8e8bfec91b939a"
  license "MIT"
  head "https://github.com/padovanl/portop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e293943c5215dc5236ac7d732cc3f8f174d38ea792d6a0991d0ab8397ec79a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e293943c5215dc5236ac7d732cc3f8f174d38ea792d6a0991d0ab8397ec79a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e293943c5215dc5236ac7d732cc3f8f174d38ea792d6a0991d0ab8397ec79a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "71d53a9ee746516aa4a1920f4e6731e977e0775299b221702153ae894212bf5c"
    sha256 cellar: :any,                 x86_64_linux:      "16b69761a677c6a563591abbc67a44afeae8d58a3f2fdbb42e2d77b81ba9804c"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/padovanl/portop/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/portop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/portop --version")
    assert_kind_of Array, JSON.parse(shell_output("#{bin}/portop --json"))
  end
end
