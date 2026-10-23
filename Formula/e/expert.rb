class Expert < Formula
  desc "Official Elixir Language Server Protocol implementation"
  homepage "https://expert-lsp.org"
  url "https://github.com/expert-lsp/expert/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "bdb5f9b88c9b28f88f8a551f73b53da97a59097ce0e8d6d4a30686db36c087cb"
  license "Apache-2.0"
  head "https://github.com/expert-lsp/expert.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "71f5f37d68f9d93bca30b841b2cd792061fe3c62b6a92a5d1935aa099eb79b86"
    sha256 cellar: :any, arm64_tahoe:       "e7f9184a06c59e4170cf5e316462a3c945697a29a4986663346b53c64dcb400b"
    sha256 cellar: :any, arm64_sequoia:     "9c19b7ce29eb583eb8297890fb21a482901fd653cd6e5784d167e1ff74c98767"
    sha256 cellar: :any, arm64_linux:       "829f11ab79ab828ea185dc3a56c7120e48af495dd72b1a81feb476389b651fb7"
    sha256 cellar: :any, x86_64_linux:      "6c4aa147d4695f41e78c0ad45e12353b4a2d1a50046d4dd0844ad4ac7289341e"
  end

  depends_on "elixir" => :build
  depends_on "erlang" => :build
  depends_on "just" => :build
  depends_on "openssl@4"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "mix", "local.hex", "--force", "--if-missing"
    system "mix", "local.rebar", "--force", "--if-missing"

    system "just", "install", "--prefix=#{prefix}"

    # Use brewed ca-certificates PEM file instead of the bundled copy
    cacerts = libexec.glob("expert/lib/*/priv/engine_source/apps/engine/deps/castore/priv/cacerts.pem").fetch(0)
    rm cacerts
    cacerts.make_relative_symlink Formula["openssl@4"].pkgetc/"cert.pem"
  end

  test do
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

    Open3.popen3(bin/"expert", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
