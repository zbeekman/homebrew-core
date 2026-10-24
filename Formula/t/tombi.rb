class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "ed55954245177a23915a775830e0f1f5757e2337b88d7b873dd2dcf89d0bec4a"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "652cd4cb66a516eeb799df66f0c1fe7113904e09c5e9465ea6fd63ac1a079339"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "02918934dd1510157dfbb7d4d9b44a1165550fb6d5e9a8c0a01bf33f4f57fc2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4dfdf854315d51530f8a66d3283599c86fa226e224a5c04e15bc0af8394a97db"
    sha256 cellar: :any,                 arm64_linux:       "ddbc57ff7062160a320088e8444346ab78d262afaf7cf45efcdfc74e109b3539"
    sha256 cellar: :any,                 x86_64_linux:      "52596e6bf40d504bad5902f9eeaec6a66a678f51e02d1066c5ae6237137f3bff"
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
