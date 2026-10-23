class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.544.tar.gz"
  sha256 "85c125f3490730d9e0f24e19898d6d6796f5d1e63ccd29397094e2cc201105be"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec8e0243b1f5a881fb31638c51cee582e49133b7802da366f7052ae87dea1d49"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec8e0243b1f5a881fb31638c51cee582e49133b7802da366f7052ae87dea1d49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ec8e0243b1f5a881fb31638c51cee582e49133b7802da366f7052ae87dea1d49"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bce732c2f2a3368dc4a6403b1dbf3850fa48a38da91144774c22416e281b7cf9"
    sha256 cellar: :any,                 x86_64_linux:      "c519a8589dd519be9b3f3b6e76a37686e20731e25bc3e66ac27147b23a6210c5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
