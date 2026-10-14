class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.28.3.tar.gz"
  sha256 "ab12d1eaad86477370a93b1cdca8ab5e4ff8465b364374d2786a8cc700d710c0"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71e810de46ded351e626447da1f46f11132f99d4cec1d099daac8805d56db2ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "71e810de46ded351e626447da1f46f11132f99d4cec1d099daac8805d56db2ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "71e810de46ded351e626447da1f46f11132f99d4cec1d099daac8805d56db2ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cef0e38e3565b30549e3ab786728d0b61cf97928f20ef51cd3d55b3002767645"
    sha256 cellar: :any,                 x86_64_linux:      "cfc7f0df85ae4b251dfb1af8301430cac575ebcd66ac7afbd57b50cb5a733938"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/getparty"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/getparty --version")

    output = shell_output("#{bin}/getparty http://media.vimcasts.org/videos/10/ascii_art.ogv")
    assert_match "\"ascii_art.ogv\" saved", output
  end
end
