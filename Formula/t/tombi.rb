class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "91e944e66ce0bca5d6cbc32cf50407512e68c269fff8be73840d903cc4178c22"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "adf7514e0c33c1ef169f970313989363897373fa04847caa585850b289477f87"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8823c2caf3d919dffcbd77fb92227481f54783cb855172322eb4b02e63ff1223"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59c87aa361d6a30df32b0603d453f6b20bc811de90d928f35e94b64ac5f75538"
    sha256 cellar: :any,                 arm64_linux:       "7154032626a555477988809ffe7fcb7cc39b2075157d3ad62ce72e0959ebf994"
    sha256 cellar: :any,                 x86_64_linux:      "3294ce612178e74862f28b2a7638e76f51474f436bfdf3af9e2135eb986c3039"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/tombi-cli/Cargo.toml"
  end

  def install
    ENV["TOMBI_VERSION"] = version.to_s
    system "cargo", "xtask", "set-version"
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tombi --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
