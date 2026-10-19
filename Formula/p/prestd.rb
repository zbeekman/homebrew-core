class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "6bcc88a8e97524732838599d80ccc33a93ee6d4c9beb568904a318dfd130ab51"
  license "MIT"
  head "https://github.com/prest/prest.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6adecf6c2c607f16463611ec16ea813c467bca3fc91db216dd3fdbf17aa31aa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1672a0d8c596d85ff2b4befc2e1aa8d1870a443b39cb5f3eb9033b8ed5855a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1e4f0ce8622375a1fae478149135dae9db107b7cdc22903ec434ebbdcc523e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7ac0a354ce18272fadc5cbeaedc5261027f2c64db12638e4f4152ba351b3111"
    sha256 cellar: :any,                 x86_64_linux:      "367b0ec5fbb85ffab1f49a2af84c88f36067114165c110d9a3fe0033e3adbac6"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/prest/prest/v#{version.major}/helpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/prestd"

    generate_completions_from_executable(bin/"prestd", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"prest.toml").write <<~TOML
      [jwt]
      default = false

      [pg]
      host = "127.0.0.1"
      user = "prest"
      pass = "prest"
      port = 5432
      database = "prest"
    TOML

    output = shell_output("#{bin}/prestd migrate up --path .", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/prestd version")
  end
end
