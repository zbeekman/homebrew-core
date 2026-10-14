class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "35d20bf5da0480931879efe609e3fc66d6eb0c23252204a804d14e72d1baca49"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8aa220dbdee93525b5b84c9f813694fd5efdb59733a67b8005b2d7c4e817ff44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1107ab9236fe0ffa350148bf628197f02e1849f5298df4de74202bad94c59114"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e61dfc2a55619cc0c14480a9191f118364d35385dfd8fa43b5ffd286730db3c"
    sha256 cellar: :any,                 arm64_linux:       "e748ee962fbef66dc3dcc6d9edb86c5047858b504d1d50d4cd23ec23fd13eb9a"
    sha256 cellar: :any,                 x86_64_linux:      "f62615b4b3a78f9fc574747e25d7e2e18bd4ea78c93c1d1e61ba97063cd1a826"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end
