class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.25.9.tar.gz"
  sha256 "267fd2de9bed5a8926f1b0d8c9f7c5777ca9e65b9f7eb2aec04fddd532b922d7"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37a663bec3b511bd899789543f3cbdff3aea07ccc980d0224db8afe3059fecd3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37a663bec3b511bd899789543f3cbdff3aea07ccc980d0224db8afe3059fecd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "37a663bec3b511bd899789543f3cbdff3aea07ccc980d0224db8afe3059fecd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7126571cbb742a37c0adcfeed2b2ccddd037ab2100209b4d66f0999e0daa0dec"
    sha256 cellar: :any,                 x86_64_linux:      "6170fb7e774c896da71083b40a129b6e468172f96542dba7eb5017b603dca975"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
