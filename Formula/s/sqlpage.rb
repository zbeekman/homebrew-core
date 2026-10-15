class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "cb5db9c6589999d9d07f19e4cd49383a59a7625bfe5ed1a7a4b2bef21afccd76"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "978ab6300adfefb27f19e0d131b81334cebf187a518e00e6f7748cae19786005"
    sha256 cellar: :any, arm64_tahoe:       "64983493044a8187956fdb807b4c9b2482ac3d622d9c65e5c9fdb8d58c25c7f8"
    sha256 cellar: :any, arm64_sequoia:     "c898afe342887976fb0992dcf0dac6ee1f8aa8d89a3186efffa20e20322c5552"
    sha256 cellar: :any, arm64_linux:       "fb5dd95b9079fed72a4aa6c3717c54a6080980011447a8ffae26683b8cf5db76"
    sha256 cellar: :any, x86_64_linux:      "9e6afebe1ca3471926e3855708efbb3a9028e0e19af016adc59d79ec0fc40165"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "unixodbc"

  allow_network_access! :test

  def fetch
    system "npm", "ci", *std_npm_args(prefix: false)
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "npm", "run", "build"
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port

    ENV["PORT"] = port.to_s
    pid = spawn bin/"sqlpage"

    assert_match "It works", shell_output("curl --retry-connrefused --retry 4 --silent http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
