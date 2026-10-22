class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.65.2.tar.gz"
  sha256 "a68c2cfdf2797b637801920759e3a31fb5197f2c60e1f98f4e0ad931c357fa27"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "507a2b88c22144fd1ec5056ed62e85831e78dc690bcdde2649438c4d9f6f57ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "507a2b88c22144fd1ec5056ed62e85831e78dc690bcdde2649438c4d9f6f57ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "507a2b88c22144fd1ec5056ed62e85831e78dc690bcdde2649438c4d9f6f57ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2b6ddbc3750fe8a93e3dc1670a0efce3031b78deb9810eac36ccb405a89c5ea5"
    sha256 cellar: :any,                 x86_64_linux:      "9687b3394488d3b038ac9cc87820e5058a0c245e225e111a852e40b070feccf5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
