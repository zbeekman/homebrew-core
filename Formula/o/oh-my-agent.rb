class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.12.0.tgz"
  sha256 "e6342413c2e906c1d9f8bb820f58146e44483b1e6bd548faac4a6c819940c12e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f757db35100db6b1993783a8c906100e2c1826f01c0060afd08aa59ded221f04"
    sha256 cellar: :any, arm64_tahoe:       "7e72d82466545d87e828c82782c08f35405920255051f52dc8aadf9c063deff5"
    sha256 cellar: :any, arm64_sequoia:     "d02da0f13dbae78c5255a4a81f11fca493f7fcb05715c7b0c94cf6603007e9c1"
    sha256 cellar: :any, arm64_linux:       "fa0a7b16692a2635a1730b27b7f1a9ed9f3c233eb1f242a4fa452b96ddcd9d1c"
    sha256 cellar: :any, x86_64_linux:      "e07584dbb608682e47849042e183712a5f612eea8e6128cb55bb272c668fcfaf"
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
