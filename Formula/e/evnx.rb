class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "35f932d79e7ca43fd74b747174bef90df07f4512fb44cef8c787ec08d338e0a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f212941d706c7e53febef6884d76475eb9a53d9439bcdfc9a0910a055535e48c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e0a9d7814458f3aecc671c73bd2f90e4471a766d08c0ae33895f55e04da8836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a094335701a3903559e53034b9e684a6c9b4ec24f74be087b19e4364b96c142"
    sha256 cellar: :any,                 arm64_linux:       "232263f9cc973147262311fd13ca52afdf6875b39b091dc6fa232e638c6cd603"
    sha256 cellar: :any,                 x86_64_linux:      "b6bfafd527d2676baaf0df335d75d69469e568fdc9ed0c96b24ce8b862da72c0"
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
