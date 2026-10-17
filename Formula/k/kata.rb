class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://github.com/kenn-io/kata/releases/download/v0.19.0/kata_0.19.0_source.tar.gz"
  sha256 "f36b33f08bf7134cbd78a582ff04e6c72e93b7ddd80a647636685d2806b9e5bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33f13c3df82a7cf8afac019f3e49ce73dbad9ebd1f01855ad45f45568d209d6a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33f13c3df82a7cf8afac019f3e49ce73dbad9ebd1f01855ad45f45568d209d6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33f13c3df82a7cf8afac019f3e49ce73dbad9ebd1f01855ad45f45568d209d6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "202058ce43e3e3cea851b024b5ed463f9fcc96fed0f1a916a22b059e4c1399da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a96923d5533fc34a992bbd928e14067d46a7486384e3acfed8bd2441984b08ab"
  end

  depends_on "go" => :build

  # `test do` block needs network access for `kata init`
  allow_network_access! :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X go.kenn.io/kata/internal/version.Version=v#{version}
      -X go.kenn.io/kata/internal/version.Distribution=homebrew
      -X go.kenn.io/kata/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "-mod=vendor", "-buildvcs=false", "./cmd/kata"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kata version")

    ENV["KATA_HOME"] = testpath/"kata-home"
    ENV["KATA_TELEMETRY_ENABLED"] = "0"
    begin
      system bin/"kata", "init", "--project", "homebrew-test"
      system bin/"kata", "create", "Homebrew test issue"
      assert_match "Homebrew test issue", shell_output("#{bin}/kata list")
    ensure
      system bin/"kata", "daemon", "stop"
    end
  end
end
