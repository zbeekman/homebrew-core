class Tele < Formula
  desc "Keyboard-first Telegram client for the terminal, written in Go"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://github.com/sorokin-vladimir/tele/archive/refs/tags/v1.11.11.tar.gz"
  sha256 "4752ea05f58a77d43d955fc2b96b61d0aa2d3e380d470a48d66a6b2579e39e0c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "012339219b2ad6f0b3b7bdbc0de41f60b0b1db6068eb2ea344323dd7643a78a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc5c96cf3850dd504ca3a7610adef79d739cc83fb7fba6228eaa1cf112bcf5f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d7822bdaea43c7bed251fde632feaab43fec95412368a846943029755078309"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6ff24f2df09fe8f1f929044f016f62c7ba526db94235815f152fee829993b6f9"
    sha256 cellar: :any,                 x86_64_linux:      "fd710c709afb5916a8b15ade9642d40aa636867accadfbca50e44830095c7998"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/sorokin-vladimir/tele/internal/version.Version=#{version}"), "./cmd/tele"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tele -version")
    assert_match "dumped from tele-dark", shell_output("#{bin}/tele -theme-dump tele-dark")
  end
end
