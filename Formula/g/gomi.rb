class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https://gomi.dev"
  url "https://github.com/babarot/gomi/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "514019cc7f87cb19f1a7c2dafd3fffaf29b3239d805f7ff8f92375124a15c1eb"
  license "MIT"
  head "https://github.com/babarot/gomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a77e2b6ff13cbbd980870c51413b2677aa1523e980d37996c58675388b5f8d88"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a77e2b6ff13cbbd980870c51413b2677aa1523e980d37996c58675388b5f8d88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a77e2b6ff13cbbd980870c51413b2677aa1523e980d37996c58675388b5f8d88"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ef07ceb84f386f54071273118f313969d744ae83abc5ff91264de7d38e5239ab"
    sha256 cellar: :any,                 x86_64_linux:      "8a681c0909bc047a67034a867e14e347cbe148c627cca5e49e456532abbeb607"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["TMPDIR"] = testpath

    # Create a trash directory
    mkdir ".gomi"

    assert_match version.to_s, shell_output("#{bin}/gomi --version")

    (testpath/"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath/"trash"
    system bin/"gomi", "trash"
    refute_path_exists testpath/"trash"
  end
end
