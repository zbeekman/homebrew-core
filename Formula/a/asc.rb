class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.15.0.tar.gz"
  sha256 "c74c89b59b3b72005ba5f3de3317574cbb9ea6b2d8f9566bd3b47a670792de1f"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cdf1aac4c55c9e7ef7ab771e88fe8d35607e5eea6bf75785404fa8855a894008"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f2b0ab71f93ff6a95699e47e6c3e192584e1f26b03f17983f7a0a4628d55a6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e104a82a22cdfb5c1dc0332e1a227e3d40ebde972aff4b61513f3f7a137fd81"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d95b0031ad9fa6f4ba19e73624b8005cc06a838217d4cd31d3a90848cf3485fb"
    sha256 cellar: :any,                 x86_64_linux:      "aed77f1298003eeb069aa3829f5241634109601b0dbe14424126a960af83153c"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
