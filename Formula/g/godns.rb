class Godns < Formula
  desc "Dynamic DNS client with multiple providers support"
  homepage "https://github.com/TimothyYe/godns"
  url "https://github.com/TimothyYe/godns/archive/refs/tags/v3.4.6.tar.gz"
  sha256 "ccec55e12aa1d22655e1c3894189902d30d7ac1a42f594dd25b5681c5dffb65d"
  license "Apache-2.0"
  head "https://github.com/TimothyYe/godns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3348a8429ddd56c530cfcbb14cc8a41539a2142508f8a8e8b8a7f3debd30ea2e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3348a8429ddd56c530cfcbb14cc8a41539a2142508f8a8e8b8a7f3debd30ea2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3348a8429ddd56c530cfcbb14cc8a41539a2142508f8a8e8b8a7f3debd30ea2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f5ef152afc2b521419df7a66b1e0429e84bdc36a45511a662acc56335132e4aa"
    sha256 cellar: :any,                 x86_64_linux:      "2ae164bd399a532555da3802d2a8b1382de9aa6b582797401ceb5649a3a44a53"
  end

  depends_on "go" => :build

  resource "web" do
    url "https://github.com/TimothyYe/godns/releases/download/v3.4.6/godns-web-v3.4.6.zip"
    sha256 "d6f0d0d1b50e1cd1957b03e3e1f40e2224f617cd641c7ed04d2d0f9a62628cde"

    livecheck do
      formula :parent
    end
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    resource("web").stage(buildpath/"internal/server/out")
    system "go", "build", *std_go_args(ldflags: "-X main.Version=v#{version}"), "./cmd/godns"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/godns -h")

    (testpath/"config.json").write "{}"
    output = shell_output("#{bin}/godns -c #{testpath}/config.json 2>&1", 1)
    assert_match "Invalid settings", output
  end
end
