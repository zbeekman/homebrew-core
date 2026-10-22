class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.70.0.tar.gz"
  sha256 "268586498e922736199097a41cfa8700a6f05e252eb7e33c7e08e3000311f8a6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a21ecf30c93e5dd2b7c466187d82052cf99b12d03e603a76606d1a8bd6797bec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a21ecf30c93e5dd2b7c466187d82052cf99b12d03e603a76606d1a8bd6797bec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a21ecf30c93e5dd2b7c466187d82052cf99b12d03e603a76606d1a8bd6797bec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "402bdb178e59ff5a7ae768dbb04b7cd6bd66cc02c7622f1ae2a3087caf609ef2"
    sha256 cellar: :any,                 x86_64_linux:      "41b07f3e26e08eeff08cb1200bd4946861a8140900960d501cb4290e815c320f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
