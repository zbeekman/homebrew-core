class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.133.tar.gz"
  sha256 "340217f9dbd4f0b68ba3ccf446e616ec0bd9505e2985efa8affe730fdc02ae68"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d67d0c1caf770ab3df2086a25f9e4793989a4ba100e2c36098ffff04e5800710"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d67d0c1caf770ab3df2086a25f9e4793989a4ba100e2c36098ffff04e5800710"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d67d0c1caf770ab3df2086a25f9e4793989a4ba100e2c36098ffff04e5800710"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16196fea79d5a1b53b025ebe5aef11c5a994a33f48c5451a71b2f24cb26d4651"
    sha256 cellar: :any,                 x86_64_linux:      "9acd9f73a9b0ab28cfa52e2bc5993767a135952ad2919dc4d343e98ed9765cfe"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
