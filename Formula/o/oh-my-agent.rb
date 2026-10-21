class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.8.1.tgz"
  sha256 "6244df6b8106270b68084716f3b896d112067a013801eac79a749e54d0eaa872"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7d61e9f5ab0318de6f5abf9c818c3cabb8d207a67f628ae9c7ee33f87bd1350c"
    sha256 cellar: :any, arm64_tahoe:       "5fa99ab73b4b94461467b3c35206332c97187e17fadb1b47561167d313beb8ba"
    sha256 cellar: :any, arm64_sequoia:     "8f91a3a4baa6d97c5ea73ca1ebd60623122900d9fd36bcbbece5b53de42865a3"
    sha256 cellar: :any, arm64_linux:       "b14113901f273691e22c2bb2409c3e432b61aa1b23b2f7d41bb8fad519ba6155"
    sha256 cellar: :any, x86_64_linux:      "95924bd15cb71d22bc16f2526b31af30088fb5442436c8d38a27f669554391a2"
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
