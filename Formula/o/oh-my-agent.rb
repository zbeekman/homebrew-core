class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.4.0.tgz"
  sha256 "bf608f310a5a3b7c13d29998bea56ab7b4a53729172836c73dd5e341a9ad8e1b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5e66c30c09ec37c6ba1636027718ee1d2b0d77d42e2e3379edb86da284183064"
    sha256 cellar: :any, arm64_tahoe:       "755ee21aed480a5f7eec6cc8d8305717760475ac64d59f1de688813bbabd6a01"
    sha256 cellar: :any, arm64_sequoia:     "99028d0b288039efa34b99b927dbce4d88ced41713bb407a6612f76aa8eacfed"
    sha256 cellar: :any, arm64_linux:       "84ee4f0c51a1da86712b8382d2085e15a9bc218d83991e0bb9f265e7fdf9327e"
    sha256 cellar: :any, x86_64_linux:      "88cf35070f51b0ffe987fc20647eea134283fd209f2feee5cbbe8b94735bccfd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules.glob("better-sqlite3/prebuilds/*"))
    cd(node_modules/"better-sqlite3") { system "npm", "run", "build-release" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end
