class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.38.tar.gz"
  sha256 "09100499aa469a02ced756c4cc013ca7b3805b327c45d87864b0fb2724b54dc1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "746aab0eff668711373a352bf5eef72132209a545e20c77ef1112b770fdbf4e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da1d120bdea602688edcfeb03cb2ba37c07aa312d501aed493320dacf8869bed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29bfc36fabc9b8c71a39a62d34c8d2cbfca4459443af0f2ec696c917b881fa8d"
    sha256 cellar: :any,                 arm64_linux:       "110732c2605f92287e0b3be4e0016a201b46dedd15fbe3521ebbf663bf5f53d1"
    sha256 cellar: :any,                 x86_64_linux:      "66e20b9a446a748b038692329fc839ebf9385e68de8b6896b88470df623ba2f1"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/a31c5230de303d342f62e0e2ecd62af83e5fcd4e/model_prices_and_context_window.json"
    version "a31c5230de303d342f62e0e2ecd62af83e5fcd4e"
    sha256 "91da1a98e194e0d7c436aaf970800c8e734d70cc78027cfe314d5b27dfaf9a4c"

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
