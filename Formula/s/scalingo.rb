class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.50.0.tar.gz"
  sha256 "81af63602eaff4d500a34f70ab54eaebf5ba119f24a910c5f3191745bb354982"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "41eb6a88138d77f8dd3ae5a453cdcf1094e40214958324cf46e6720c6ee0a329"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41eb6a88138d77f8dd3ae5a453cdcf1094e40214958324cf46e6720c6ee0a329"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41eb6a88138d77f8dd3ae5a453cdcf1094e40214958324cf46e6720c6ee0a329"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dfd81ef15dcfa11e518cdf3d7be111adea13162ec83ec851a1f96c31f3d021d6"
    sha256 cellar: :any,                 x86_64_linux:      "fa5eff31d7392b85f192db88ffc2c573d2ec5e7497cca97149c8a5a8c597bb55"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      ┌───────────────────┬───────┐
      │ CONFIGURATION KEY │ VALUE │
      ├───────────────────┼───────┤
      │ region            │       │
      └───────────────────┴───────┘
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
