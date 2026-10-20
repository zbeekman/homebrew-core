class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.165.3.tar.gz"
  sha256 "4991c1d5314d9a8932efdfc51674dee0870a35c07cb8be6f9798e8f8419c8ac3"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bcca7a152df19d5845ccc9a14ce8ea6563a4f36338056bc68b4d815f231d6c4a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bcca7a152df19d5845ccc9a14ce8ea6563a4f36338056bc68b4d815f231d6c4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bcca7a152df19d5845ccc9a14ce8ea6563a4f36338056bc68b4d815f231d6c4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e50b2ca51e284c60545128de06dfc7174131f96401c3c4176b23764094d79e17"
    sha256 cellar: :any,                 x86_64_linux:      "dea1fddb0b182a5ff03191f5acedc57e1535ac7c97f991583781cb6e611b154e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
