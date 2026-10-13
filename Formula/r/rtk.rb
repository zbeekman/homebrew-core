class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "37106f842d1575cc1d05c82675808ccdde1e778c363f9643cbac6f0a596b9ef7"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07064d891c9f56f0d4a514febc9fa2feb9dad01190634c60dd2d16c0756a0b93"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83b521edb701ee57056c231b30fca10efbd2a075a01522ca70b9bf905743964f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d320cc461769a793a044344d1615144a365e2eea9949acf82f70b69a47ce34c0"
    sha256 cellar: :any,                 arm64_linux:       "d2b41a6101c27c919aa386fae5b77514bd7218f4fbda7e5804f1440fe671e542"
    sha256 cellar: :any,                 x86_64_linux:      "3aa70ca8f6d23836a1041620ae774c1fa43c7a01a925208b3015979a28b5370d"
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
