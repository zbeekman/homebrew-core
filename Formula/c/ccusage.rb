class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.35.tar.gz"
  sha256 "eec8116ac9e23af72ef05546058244ad4fc29dbed59e8c587924ac5b50b77d57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37b2a4570d0690757e743b1ad4589f5155ea592f830f24e6cd517d879074be6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00b8c8bd06ab39721b269fe3512d9bc0c76636732a30722cceaeb175e880a2f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c68ced140e10c17915dd7d45fee23571b82f125df95f2f8ea086710968198eb"
    sha256 cellar: :any,                 arm64_linux:       "125a472e06c5d315c6f1a78df7f3605b02f30572f74c5506882676d473d149f1"
    sha256 cellar: :any,                 x86_64_linux:      "85c1d92b61e266ae0987f475d106997486f03224c2cf95f5e9efd1c54a33a9db"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/bbd446b476526864e6f0abeb3a6cb6728e9772ed/model_prices_and_context_window.json"
    version "bbd446b476526864e6f0abeb3a6cb6728e9772ed"
    sha256 "9bd941471d13e11d4a7083fc5274c64a7049073f23b03bbb511db8e5a36b6416"

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
