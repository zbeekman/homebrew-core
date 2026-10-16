class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.17.0.tgz"
  sha256 "fe2d68605838d8eef08807d914a0c07a43cf7c648e03db9617194e100e0dfb77"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ce0a4e93b9615c516555c8477c8440d4d3c91ba3880d9148544dc4897d3fe226"
    sha256 cellar: :any, arm64_tahoe:       "ce0a4e93b9615c516555c8477c8440d4d3c91ba3880d9148544dc4897d3fe226"
    sha256 cellar: :any, arm64_sequoia:     "ce0a4e93b9615c516555c8477c8440d4d3c91ba3880d9148544dc4897d3fe226"
    sha256 cellar: :any, arm64_linux:       "a42a14a1fcaac35bf33cfdb2fe0c5bd6793f13669c5a4389aab615f6641aa44f"
    sha256 cellar: :any, x86_64_linux:      "9623dbb6614e5d5e71d640412214e27e46f0c3156b0de25d3e07c7ad9226dc13"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["HOME"] = testpath
    ENV["CI"] = "1"
    ENV.delete "SANITY_AUTH_TOKEN"

    output = shell_output("#{bin}/sanity debug")
    assert_match "Not logged in", output
    assert_match "No project found", output
  end
end
