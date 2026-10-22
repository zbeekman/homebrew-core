class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.535.tar.gz"
  sha256 "2933cdbab03bf2e4a2a833cfbb643ca8397aca5c7048aa03a14435bfefec2049"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f27b544e3168f8e09c2f1130204d18fd77505f034c6ab6c2d9ace13cf836d44e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f27b544e3168f8e09c2f1130204d18fd77505f034c6ab6c2d9ace13cf836d44e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f27b544e3168f8e09c2f1130204d18fd77505f034c6ab6c2d9ace13cf836d44e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7ff93b16445c5af67629e38e2feeb4b7c89d8bca7a3f78b5609456914eeb816"
    sha256 cellar: :any,                 x86_64_linux:      "d7499f65280179feae530ec8f3bc0aeac4d7be6c1acec280d40f9c850c0522e1"
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
