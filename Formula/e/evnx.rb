class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "28e06abf4ecf0b4bd4d196390b3c8a426d017af33ab0f98b96656cef0d9193b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11a220febe3c222419f6a89d08ef8797dccdaf5370db0924187732f1e9f5aa51"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7aeb4ad22d330c12162d71c077df6faa72f729ab30382893fc90f05cf44f5ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a61885090ca40f92a75ece5c8370e9e7fcb0a3cedb0e01280db54426bc3db4e2"
    sha256 cellar: :any,                 arm64_linux:       "c27a7ca48e3efdf7d6d1a1313fdb4d2b0d0967da11f3a253cad10d24ed07bb98"
    sha256 cellar: :any,                 x86_64_linux:      "8fe4f1070d848d6d7f79e4feb29f95568ebad05dc476dee1168a4741e16d5305"
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
