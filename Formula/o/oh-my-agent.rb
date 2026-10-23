class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.12.0.tgz"
  sha256 "e6342413c2e906c1d9f8bb820f58146e44483b1e6bd548faac4a6c819940c12e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "578f466d6e662de4213efe791e598459b3389bd633166295b3b8c11802a6e772"
    sha256 cellar: :any, arm64_tahoe:       "b5dbc856b07ef129573f50353b7145e3c78464736c1104a959994e23b07c3355"
    sha256 cellar: :any, arm64_sequoia:     "3dd28a60bc2d25ca1c580ab3c77d3381d1a829fa9118a344914cfd2b0105b71a"
    sha256 cellar: :any, arm64_linux:       "08fc5b56f05d1d33c8786656b447bcdefd73ac0015e384ef5d09815d6d1fe4a6"
    sha256 cellar: :any, x86_64_linux:      "8ed17bdd644ddf162d4f844273f40b8acd7f42ed153721dcd97724cd6a25f7ec"
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
