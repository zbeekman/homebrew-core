class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "28e06abf4ecf0b4bd4d196390b3c8a426d017af33ab0f98b96656cef0d9193b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a0483258f75ab71c2dc8ba0a3975d483528d3a7c7c17ec68e8355a5c65764e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "640a07332093e294472aa8a591a3c5eec22743ab3922d0f112de3a74607ebf55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bddc809f70c7bfe974c1e0b4ad34a4daf12973fbac733ccd2996c4d197f9506"
    sha256 cellar: :any,                 arm64_linux:       "4c9eedc0ddad522f8ec01b6e35bd822bb60a6b89409a251187f638117efc85bd"
    sha256 cellar: :any,                 x86_64_linux:      "7a24feb4f9639a036319b8c6b0913f4f79e929c4db88ae36548c969d56e0398f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "All checks passed", shell_output("#{bin}/evnx validate")

    (testpath/".env.example").append_lines "API_KEY="
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end
