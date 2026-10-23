class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.152.0.tgz"
  sha256 "0937cb6f17b28c012f7d745c137c4e5c4135b81b2cde836d37022615c9d3d690"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3032202b2b8dfd2dee883f05e1e10d45be3eed97f1b5b2cc782d10e37c9d29f8"
    sha256 cellar: :any, arm64_tahoe:       "3032202b2b8dfd2dee883f05e1e10d45be3eed97f1b5b2cc782d10e37c9d29f8"
    sha256 cellar: :any, arm64_sequoia:     "3032202b2b8dfd2dee883f05e1e10d45be3eed97f1b5b2cc782d10e37c9d29f8"
    sha256 cellar: :any, arm64_linux:       "04426bb36d8225ac113010327fef3e7c81ce8a8c5a36e58a9e35b1515cd0746b"
    sha256 cellar: :any, x86_64_linux:      "bb1a761db4d1c6ca73f847642fb6ca8d7668d0290a3a6acb0f661688e3ea984d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    generate_completions_from_executable(bin/"wrangler", "complete", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
