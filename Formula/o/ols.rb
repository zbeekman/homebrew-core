class Ols < Formula
  desc "Language server for The Odin Programming Language"
  homepage "https://github.com/DanielGavin/ols"
  url "https://github.com/DanielGavin/ols/archive/refs/tags/dev-2026-10.tar.gz"
  sha256 "49ce783760429421645f6b4125dda374154148fdfbcb66fce61f772dbfaba851"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1eea32145df80d1bba93312ec2f550b41dcedb3aab32265522e029fe09a3d86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a5a601616565b0bdcfaa484ffe0f589677848e88592b16722d48febeaa01b91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52f49213b3a19715408ff48c32af6105d876955e22ccb39b60c4f11eacdc0007"
    sha256 cellar: :any,                 arm64_linux:       "12d2f63811a29d6d45042aa194651bd77d843038d925be9bb926062d67d22fd9"
    sha256 cellar: :any,                 x86_64_linux:      "d454e3a6cc1e7d657c826533524b87b56bbf3b728775b68319515a743a253f72"
  end

  depends_on "odin" => :build

  def install
    args = %W[
      -out:ols
      -collection:src=src
      -define:VERSION=#{version}
      -o:speed
      -no-bounds-check
    ]
    # Odin defaults to x86-64-v2, which is newer than Homebrew's oldest supported x86_64 CPU
    args << "-microarch:#{ENV.effective_arch}" if Hardware::CPU.intel?
    system "odin", "build", "src/", *args

    libexec.install "ols"
    pkgshare.install "builtin"
    (bin/"ols").write_env_script libexec/"ols", OLS_BUILTIN_FOLDER: pkgshare/"builtin"
  end

  test do
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

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"

    output = IO.popen(bin/"ols", "w+") do |pipe|
      pipe.write(input)
      pipe.close_write
      sleep 1
      result = pipe.read_nonblock(65536)
      Process.kill("TERM", pipe.pid)
      result
    end

    assert_match(/^Content-Length: \d+/i, output)
    json_dump = output.lines.last.strip
    assert_equal 1, JSON.parse(json_dump)["id"]
  end
end
