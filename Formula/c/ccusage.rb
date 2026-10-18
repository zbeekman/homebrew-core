class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.36.tar.gz"
  sha256 "fbf05898640a745f257078f2b067a6a1da0fd0c872599ef6c921b4e89b0a8198"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "540e2049b25854bcfe03e0b02319d21fec890feee76356c47151b50cfb289c8d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d5bf1f66fc50ce8cd9e7e6bd72dd537521ed397d6e9374ecf75618377c60c68e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d0805370c8eaa8b9e9830125d5d5a342cb72621d06e2d55a8c1f4a9b9c53582"
    sha256 cellar: :any,                 arm64_linux:       "5b44198c920992686372d2902b1458484c7c39ef6d7df44c1ad7914cf9c0a1a4"
    sha256 cellar: :any,                 x86_64_linux:      "11e6427313b992d5d148ef5ea7cd573727e8c01ad10c5e48ec3b0108bc950a0b"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/9c958aff349680503a5d9785b3ef507eb9822002/model_prices_and_context_window.json"
    version "9c958aff349680503a5d9785b3ef507eb9822002"
    sha256 "da798353b3d14c09a13f2f1fe42eaf903212c158bb6d94d724836225c68d865d"

    # Fetch the latest available resource
    livecheck do
      url "https://api.github.com/repos/BerriAI/litellm/branches/main"
      strategy :json do |json|
        json.dig("commit", "sha")
      end
    end
  end

  deny_network_access!

  def fetch
    cd "rust" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    resource("litellm-pricing-json").stage buildpath
    ENV["CCUSAGE_PRICING_JSON_PATH"] = buildpath/"model_prices_and_context_window.json"
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end
