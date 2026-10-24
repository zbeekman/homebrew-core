class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.44.tar.gz"
  sha256 "3f3faa51e437b091c3c85e341cc57c85cb852079689bdd1a83658625a532a938"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b54bbd3d5cce240c79736ef3535ac267fa5aedd73b31092adcd16352c077c9f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d8341b01ea5a79dda3772a20676b8b5c01c296699295454ac8c47d3ba72d258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ebc8a7aa2cea6d6ae4b768cb057228ce93a23c73f2cca5cbff189f7255c8dfb"
    sha256 cellar: :any,                 arm64_linux:       "4ee1ed361bbb7b53a0c51f2c93751793cca68d4b47e5b06f47847014645ad6fd"
    sha256 cellar: :any,                 x86_64_linux:      "2ed3ead5a87109eeb848b8595f5dc0ac2631dd267258e5922e27a980350d7001"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/1418c1990fcc403d7598d97832f1272f45049299/model_prices_and_context_window.json"
    version "1418c1990fcc403d7598d97832f1272f45049299"
    sha256 "7cebbf93cc81f6cf20763782eb0122020c86e1a7ea164bd53ada49d4dc14a773"

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
