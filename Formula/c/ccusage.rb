class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ccusage/ccusage"
  url "https://github.com/ccusage/ccusage/archive/refs/tags/v20.0.32.tar.gz"
  sha256 "0c96e9c79b28554d5ba46a2a5e1332be0e2483e56ed2c11164e03b7082669c7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c5dc2647231f2f8e8b2566cdac14f469169117c257b791619d6872648bf4af1f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cca0cf95f244f25a67b4debc786dcd24183a7baa6d3d57a19108643643b5800"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c54c077ced544d84a7e90a70af475f55e9d992895597448a32127b24b62123c5"
    sha256 cellar: :any,                 arm64_linux:       "7e5b15e30e49bfa813d4b9e4f4cc317be68b813309f6a55e6c4026a62b551a34"
    sha256 cellar: :any,                 x86_64_linux:      "d2836212585784d3cc4e538e11694fb5235380d9d54e9229512d7988d02c051b"
  end

  depends_on "rust" => :build

  resource "litellm-pricing-json" do
    url "https://raw.githubusercontent.com/BerriAI/litellm/aa0279e0a23a4e983141e6df1556df9926a4f3ce/model_prices_and_context_window.json"
    version "aa0279e0a23a4e983141e6df1556df9926a4f3ce"
    sha256 "2f28121f02c9b891078b14eee0d8a0a185c744583a6c5e1f389cc8d39090080d"

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
