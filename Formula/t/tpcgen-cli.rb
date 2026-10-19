class TpcgenCli < Formula
  desc "Fast TPC-H and TPC-DS data generator"
  homepage "https://github.com/datafusion-contrib/tpcgen-rs"
  url "https://github.com/datafusion-contrib/tpcgen-rs/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "25685eb523fad909b65aa307ef3c585c46c20e48a01f340c65edb6abc4aed029"
  license "Apache-2.0"
  head "https://github.com/datafusion-contrib/tpcgen-rs.git", branch: "main"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tpcgen-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tpcgen-cli --version")

    system bin/"tpcgen-cli", "tpch", "csv", "--scale-factor", "0.01", "--tables", "nation",
           "--output-dir", testpath
    assert_equal 26, (testpath/"nation.csv").readlines.size

    system bin/"tpcgen-cli", "tpcds", "csv", "--scale-factor", "1", "--tables", "income_band",
           "--output-dir", testpath
    assert_equal 21, (testpath/"income_band.csv").readlines.size
  end
end
