class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.539.tar.gz"
  sha256 "3881f27bc02f5cfbe0466fe987c2c3e080ddb39af578a120b8f92e7247f09d75"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b5cc045f0aac40f172390749f311b879d1cc41395b8850244be844c18bb1ca6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b5cc045f0aac40f172390749f311b879d1cc41395b8850244be844c18bb1ca6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b5cc045f0aac40f172390749f311b879d1cc41395b8850244be844c18bb1ca6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "39e53f779277233f231d3e0cba25003416da9b273388361ca330a111b2c38b67"
    sha256 cellar: :any,                 x86_64_linux:      "730eb07b534e792d58a2a1f671c6e933d7149700562becad5fae8abbdee3ff06"
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
