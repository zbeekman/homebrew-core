class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "224cdfdd705856d703187a9ee09911cb499177394ec5f3b993d7abc127754e1e"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4dfa0aaf9899dd123343c7b030cd965c540395258e8a250328b697853c45b24b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ed9ac2e516ce42d607d511fbd56e8b1bc9ee082a27df13a0b9c7336ed91b6d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8bfaf213333c07908bb889b0818c4009adc5c0f97620fc87a9c4f82ce0b66ade"
    sha256 cellar: :any,                 arm64_linux:       "0e49a2e91497585b1521406e5a88146829ed298a460d2964b57615140650f10e"
    sha256 cellar: :any,                 x86_64_linux:      "922cafdec67c47b14da0181af632aa8ad3a7aa45e2815ab56d1a0640425267b9"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rover", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
