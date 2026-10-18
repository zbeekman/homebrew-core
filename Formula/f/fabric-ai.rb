class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.526.tar.gz"
  sha256 "8414d16dc644758c49425e8658402c73cc788602a5aea928549f313a9f6e2158"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76580f20cfbe211a4e763791896a210b6bdfedad68f3db9d73650b2e665b68ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76580f20cfbe211a4e763791896a210b6bdfedad68f3db9d73650b2e665b68ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76580f20cfbe211a4e763791896a210b6bdfedad68f3db9d73650b2e665b68ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "195c68ae1320da5665f1b94e2bcf7bb06a86c4bb87ccc4d5db26736714ca04d8"
    sha256 cellar: :any,                 x86_64_linux:      "b9f8bf779dbc066a094d29d91843fff0bb6bee1d92dba7b4e10ddbbc344144a9"
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
