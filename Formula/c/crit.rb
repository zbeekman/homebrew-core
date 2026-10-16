class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "4b1c0f9835f752ac07014ef306a60051f4fb1839f1911f8916eceff0938f2383"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a83bc136fcea77294d4ac8e48bd7148a64a60799182775d782c0e867f6442b5b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a83bc136fcea77294d4ac8e48bd7148a64a60799182775d782c0e867f6442b5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a83bc136fcea77294d4ac8e48bd7148a64a60799182775d782c0e867f6442b5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7e7751f12aa34e7ea0e90fe79be563ebea225853f8ba000875f758fa9446f931"
    sha256 cellar: :any,                 x86_64_linux:      "bcebb1c86b1bf4eb4df89301f0f7ad80f4e9116676eb4ae7e015a4523276b7a6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    assert_path_exists testpath/"reviews"
  end
end
