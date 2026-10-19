class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.37.tar.gz"
  sha256 "f7a1439f5c4ecfe064d8e9126eba3b973873fde1a63c66231296f352a7767c01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82589b113c4162ba6d44d0b5650487f5a7690c714741eb326bed2a18eb6999d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f61c37b40926f96635dc15968d462cca00f9a53be45a162ca75341bbabe9742"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "80bebc4925a9ffef235da5d58b920c7976d379a6bee77ae2fdf322ec67a8a851"
    sha256 cellar: :any,                 arm64_linux:       "e677c6822479a05a826311f19337bed24cee913b437901c75d2cc1b5746ac452"
    sha256 cellar: :any,                 x86_64_linux:      "2e61f435b0b61d5f09b41bea736dbc8c23ee11f94fd8c8aaaa72ae3039e8fe87"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/2e427c6247903b133bd8e3db9076bf5d70d3f9f0/model_prices_and_context_window.json"
    version "2e427c6247903b133bd8e3db9076bf5d70d3f9f0"
    sha256 "4b2eb0bc07e995417a7e10a39b442fb6cd95b1df3ca9fcb580a189d094b67355"

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
