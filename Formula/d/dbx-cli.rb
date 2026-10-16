class DbxCli < Formula
  desc "Command-line interface for DBX database connections, schema, and safe queries"
  homepage "https://dbxio.com"
  url "https://github.com/t8y2/dbx/archive/refs/tags/packages-v0.4.121.tar.gz"
  sha256 "cbcf92e1d230c2c41de64bc9ec302394e78514cd1b5cd6085fa5c2da860d2e99"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^packages-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "023543fe4d168e78e9a1226c27480eff311de714d653bf1ed5e7b08db54f9a25"
    sha256 cellar: :any, arm64_tahoe:       "079f44a051de9a36f93249119fc7b30d23b193e713475fca8ef7ccf0a7ebce07"
    sha256 cellar: :any, arm64_sequoia:     "c82e439b01ca09a7e5bd0ee13aaee87f7d681b36ae6ed3b4f17b4c54eb6140db"
    sha256 cellar: :any, arm64_linux:       "b737a66ff18598e358b7a67d1c92d715607f7506a0ed4010b75f2e5346ebe0c6"
    sha256 cellar: :any, x86_64_linux:      "50098235432277fdfd1dfbf8364a70813f7eb86d8af27db03eb0be2e3a7c6be0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dbx-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbx --version")

    output = shell_output("#{bin}/dbx capabilities --json")
    capabilities = JSON.parse(output)
    assert capabilities.key?("directQueryTypes"), "Missing directQueryTypes"
    assert capabilities.key?("bridgeRequiredTypes"), "Missing bridgeRequiredTypes"
    assert capabilities["directQueryTypes"].is_a?(Array), "directQueryTypes should be an array"
  end
end
