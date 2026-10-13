class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "1b8ae0fd469081012c2ead4aa6e587033beb40fb0d6d005e7cec1ccd9474f567"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21e4bfc344f6dadd8b16e2c3aa821da605a24bc0c3ac00d5ce0c9e44452edd6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b18fce4c5b9cdbc550d3497d8dbf0b768b50c967b61ddadcdce182fccb125362"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c1b4bc9e40bd2f4a2b2046c21641b2efda4f5416b098635a7586b872b6cbc33"
    sha256 cellar: :any,                 arm64_linux:       "d9da01ed96723650920e1ab1b95572fe1769291f822405b68fd41121db08b0bc"
    sha256 cellar: :any,                 x86_64_linux:      "a89b71ab7317f2a00d18841b53b8d856f77760144e0a8b8014bbe37cd66167ba"
  end

  depends_on "rust" => :build
  depends_on "node"

  deny_network_access! [:postinstall, :test]

  def install
    system "npm", "run", "build:native"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  def caveats
    <<~EOS
      To complete the installation, run:
        agent-browser install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-browser --version")

    # Verify session list subcommand works without a browser daemon
    assert_match "No active sessions", shell_output("#{bin}/agent-browser session list")

    # Verify CLI validates commands and rejects unknown ones
    output = shell_output("#{bin}/agent-browser nonexistentcommand 2>&1", 1)
    assert_match "Unknown command", output
  end
end
