class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.540.tar.gz"
  sha256 "cb3311cba9753413ce53053c98907e5df4a7ec0ceafe83bfeca84a15b628f96c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74dd9867d5228252c6d3786e8923fa7a05f72a953a5bb9506a58420d68d7c3cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "74dd9867d5228252c6d3786e8923fa7a05f72a953a5bb9506a58420d68d7c3cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "74dd9867d5228252c6d3786e8923fa7a05f72a953a5bb9506a58420d68d7c3cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c063bfd790c6d37a31aac22f0054ce9a145343f81cac63293d60bd3b24279471"
    sha256 cellar: :any,                 x86_64_linux:      "e2b464eb0d9498c927ac39c9bc0f82f8766c3607f64817599be7e29a1eaaae14"
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
