class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.9.0.tgz"
  sha256 "88d09a794ca6e63b7cc5fe5e3a21167831b1289ef01133d562e9073ffeb5a732"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aa1cbd74bce71d51f960db27ee3afe00b9f72cdb66b82687026dd85194de6774"
    sha256 cellar: :any, arm64_tahoe:       "8c2bc7ca171a2c36655a1da4ac66ee1df117f62be8f74629b030897bbcc2d955"
    sha256 cellar: :any, arm64_sequoia:     "44e7fac63df07164f5a1838aeab83165032bb93d0f25bc6aa8d6336f245b0549"
    sha256 cellar: :any, arm64_linux:       "b9897b8ccacf02fe6da6d94a8b22781cf40fc8231f4839a18b0ac4615bf9b854"
    sha256 cellar: :any, x86_64_linux:      "79e5a74e4058fa67ed85b550e3feb171390227d6dc3cb7e22fc6f8472813f471"
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
