class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.17.2.tar.gz"
  sha256 "32bcb3363a9b5e0111c25c5cd50069b2bd92e370695ba981d5dfbc48e7ecb1a0"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23a1f5ed9a436d3451cc08d65ed571e6901cc2d8379f81027bf5c4368cbe8695"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1eb630b486bfed5b1ffe9a898a9fcb9e477282a563d12d2a0a84fd542d376006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7420cfb09ce4368bfd540b690cf2f13210ac929d93bfed9f3258b2fcae4cfe9d"
    sha256 cellar: :any,                 arm64_linux:       "d5e3b9c5ca1ea3bbabda21b0461e6c8261ef064c0d9d6633230e75658e8d0a85"
    sha256 cellar: :any,                 x86_64_linux:      "009bcce56f2252bb205222d028286afcbc803562664ef9a7d05b2be06ff89892"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end
