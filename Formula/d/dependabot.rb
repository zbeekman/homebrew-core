class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.95.0.tar.gz"
  sha256 "cd387c2d4dbf7810fbef4838ec6645eada9a86ef5725215ba9e657c7d0fa685c"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08a5ce2fad5ac6c95544905da4ae435588817e74378066f65e9e5f165ffff52a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "08a5ce2fad5ac6c95544905da4ae435588817e74378066f65e9e5f165ffff52a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08a5ce2fad5ac6c95544905da4ae435588817e74378066f65e9e5f165ffff52a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b856ac25cca2709694893b69d1fd88a793df3230f67d6a4f6f659833a5e06e53"
    sha256 cellar: :any,                 x86_64_linux:      "18455cb865ecfd67bd0317c6872c768c1069aa1f0c71f7b3f938dd106929f4f8"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end
