class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.522.tar.gz"
  sha256 "d03dadb7b1465403c4c4f38ba4fa2ac7366032562ead56855c2d37157b9454c6"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b04538f69eab52c23a7d6d9331ea33bedf2f0629841b46d4ad0ade899d0730b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b04538f69eab52c23a7d6d9331ea33bedf2f0629841b46d4ad0ade899d0730b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b04538f69eab52c23a7d6d9331ea33bedf2f0629841b46d4ad0ade899d0730b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9a9dac71b4a83502a34324f2334e76a6ec501d6bbd17aa459902004b6dcd233a"
    sha256 cellar: :any,                 x86_64_linux:      "c764501b8576fc16a76ade893d9491582b4b33512525b7920bb2c6d42825d1f4"
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
