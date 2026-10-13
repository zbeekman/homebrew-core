class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.31.tar.gz"
  sha256 "a7287b314988940a77b5f7f23774139ad68c2a944b3b498f5ad4b244348a72e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c3265b7ab13c24de4cde6028bf7d9b3d7cc2e0e8a8742c7c290659e0d0c97aee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36011386ffd7225e4c2b9e486f3f98cac8495192fd950bfcbb7eb16a2bc3c612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f67bca99c578639a9633a7571db88383fefecd436f578f7ba99b4b2b97cfa8b6"
    sha256 cellar: :any,                 arm64_linux:       "0550fe8ca4193630784ecdaaf80831e623885a4f2f59628e60ffdc4594c2064b"
    sha256 cellar: :any,                 x86_64_linux:      "cd16819986c0090d8f82da0aa1c55259ac4a615434be76429ffe3f9609cc70ad"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/22000e1818d24c91ae2df0c15abdfb3e1e1aea74/model_prices_and_context_window.json"
    version "22000e1818d24c91ae2df0c15abdfb3e1e1aea74"
    sha256 "6b5e1ee7e77f02c7afd4a130099d48174aabb157389de3a7512c5e1d1063e403"

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
