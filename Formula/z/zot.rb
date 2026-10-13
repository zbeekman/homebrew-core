class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.31.tar.gz"
  sha256 "82b4365ecfc976c11457fd813b8d7c96bd3a9bb1f6d629bf728751b12f8f021c"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ab11ef91033f151b36b49e9ab55b94f33692009cd2453bd34fff3090dea3804"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ab11ef91033f151b36b49e9ab55b94f33692009cd2453bd34fff3090dea3804"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ab11ef91033f151b36b49e9ab55b94f33692009cd2453bd34fff3090dea3804"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fcbee355ec8d9a2cb51117b604cc5defd737f4643cc6eec386aac520a2562d90"
    sha256 cellar: :any,                 x86_64_linux:      "502308082ef81987c0bcec721a34fb8cff7f7c6ba082ee68825104c5adee6ab6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
