class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "f2c9d359610c4473615fabc74900859b91f49db767122d750ec59ce6371576be"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d916f6320fcc91942a055031b2f8cdf59683af00ccc14bccb8f1882eb5127b46"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c427c554c533ef5053e6800020841e6e84bced18c75be1f0c3e33aa9a393235"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "48c7f3987258c2e0f0991596374502a941683d88c5365c300d8202f7cbe24b0a"
    sha256 cellar: :any,                 arm64_linux:       "26fbbc4ef23a5f83a46d012f7773f15422f8830e0f149c9c0239f24b3308623b"
    sha256 cellar: :any,                 x86_64_linux:      "8c3297e4ce89417da74b9e1c6fe3acba87fd187f4e312aea5997f77e91a9afb7"
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
