class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.0.0/pup_2.0.0_source.tar.gz"
  sha256 "7e750ec41f780fd7059b7e236f88cb8fe9f7b33721c1535d4b4f839443e933b0"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "939fd7d0c86ec5d7e5c0aa87bfaed7c4b9c301076d2c80858088532057be4d1a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04f20770ac59d2d7fb0c7f551f4ad746abe2177b5f81253fdf31338f32f245d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2fc8a1244b9670117ea02a3baeb020a841dbcb5b9173380f5ebb6fb468c653fd"
    sha256 cellar: :any,                 arm64_linux:       "65a9d7af2159c0e0578f1049437baed38df62ba3f4e02f7f90eba45bed20ae05"
    sha256 cellar: :any,                 x86_64_linux:      "67ee1b676ff6eb8c0e9ea4dce1cd6015e69f83923fc18d5c882d0083608635f5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
