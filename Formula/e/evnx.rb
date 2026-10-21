class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.14.tar.gz"
  sha256 "ecf00d0dd039fb31b34b750ba4648a70cd40aa1e6c3d0a71d3c851550d61d2a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "955d274b6067ce91d6c500d19fe2f7b9a16ad8e615ab114dd43481ac0a19f467"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9d3202d70c68f378133f3f94e7212275cb38994076e975107ae8d7c1e0935eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aa592e66589572596f9ad8ab7daf8ecc552fa1fa291fed92b054be4348c20c27"
    sha256 cellar: :any,                 arm64_linux:       "19f720d99f87e0ab148677b607b7bae91c94f8e4ef54dc2b61e836e525b65d30"
    sha256 cellar: :any,                 x86_64_linux:      "146c9505d55d0c13bc92acc14879aceb2aeb79ceddf6d26d8ee41e7ed476a968"
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
