class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.dev/"
  url "https://github.com/dominikh/go-tools/archive/refs/tags/2026.2.2.tar.gz"
  sha256 "f957eca5ee25bba46711433bfc320e0e900304ebb89641264bde256031926139"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "27d14fee5712c5868cd45a459fd20eb2122b4384b053845b30fc720662f11b6e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27d14fee5712c5868cd45a459fd20eb2122b4384b053845b30fc720662f11b6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27d14fee5712c5868cd45a459fd20eb2122b4384b053845b30fc720662f11b6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14bef82d5616e1d707d285f83dfa091449f595360a46f622bf0cda5b16c76d85"
    sha256 cellar: :any,                 x86_64_linux:      "ed781efa38db864e5b8ec1b9a5fa8768358098bae3f3c3906e5182b10507f3c1"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/staticcheck"
  end

  test do
    system "go", "mod", "init", "brewtest"
    (testpath/"test.go").write <<~GO
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    GO
    json_output = JSON.parse(shell_output("#{bin}/staticcheck -f json .", 1))
    refute_match "but Staticcheck was built with", json_output["message"]
    assert_equal "S1021", json_output["code"]
  end
end
