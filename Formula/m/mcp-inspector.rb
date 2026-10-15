class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.11.0.tgz"
  sha256 "f316f4e4cb25f8ea052c733cad14b530c6eb6e89f6f9b9370d7022e49ab8b757"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "924a88135da9a71dd21f52a92b58b0a96a6dd93e423b5e2e6386cb52b938e7fe"
    sha256 cellar: :any,                 arm64_tahoe:       "9f04bbdd8118d917d0e053d6fcc45561f3dfdcbaf904f959fdef0a605737a9b7"
    sha256 cellar: :any,                 arm64_sequoia:     "9522ea87ac02256905042386a6fc07f31f2d10c627050ee1eb20e02430f07d9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0f24ad1780d03d999c7c91521619568995bb2f9b8dd3f5282f618e870c226e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a03a6a3c2a6776358f7f1d498ca1e41937f3df1dadafb27b4967e8ea7a429eda"
  end

  depends_on "node"

  on_macos do
    depends_on "cmake" => :build
    depends_on "rust" => :build
  end

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown/archive/refs/tags/v1.2.13.tar.gz"
    sha256 "f22d36d1dc3fc068274149b5e699058657a3f7da1802aee42e7e667f3a31cf04"

    livecheck do
      url "https://raw.githubusercontent.com/modelcontextprotocol/inspector/#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/rolldown", "version")&.[](regex, 1)
      end
    end
  end

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.1.tar.gz"
    sha256 "b1f4847eb61306e8c4f1a0418bf9e47231e8fdbc41a88631777d5cfa515eaaaf"

    livecheck do
      url "https://raw.githubusercontent.com/modelcontextprotocol/inspector/#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/@napi-rs/keyring", "version")&.[](regex, 1)
      end
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    node_modules = libexec/"lib/node_modules/@modelcontextprotocol/inspector/node_modules"
    resource("rolldown").stage do
      system "cargo", "build", "--lib", "--release", "--locked", "--package", "rolldown_binding"
      dylib = Pathname.pwd/"target/release/librolldown_binding.dylib"
      node_modules.glob("@rolldown/binding-darwin-*/*.node").each { |prebuilt| cp dylib, prebuilt }
    end

    resource("keyring").stage do
      system "cargo", "build", "--lib", "--release"
      dylib = Pathname.pwd/"target/release/libnapi_keyring.dylib"
      node_modules.glob("@napi-rs/keyring-darwin-*/*.node").each { |prebuilt| cp dylib, prebuilt }
    end

    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    port = free_port
    ENV["CLIENT_PORT"] = port.to_s

    read, write = IO.pipe
    fork do
      exec bin/"mcp-inspector", out: write
    end
    sleep 3

    assert_match "Starting MCP inspector...", read.gets
  end
end
