class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.11.tar.gz"
  sha256 "1ce149d8f7a12802f9a8f8537c87398766fbb9d1fc92f671672cd8904d5dbe96"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3eca2d972941adc236499967a52cca90b23bb27f1b9bc1b54bea500dd41a5c5f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3eca2d972941adc236499967a52cca90b23bb27f1b9bc1b54bea500dd41a5c5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3eca2d972941adc236499967a52cca90b23bb27f1b9bc1b54bea500dd41a5c5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "98f3d229d040721ab4a29a73cc3f33cbc3ca285cc0d42bf7d0d0f1b57cfbe72c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5eb307bd9a9cecb223fd7bd941fdd84d55111ffb94305e5d44d188ede90456ec"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = "-X github.com/threatcl/threatcl/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    # Other examples remote-import files that need `allow_remote_imports`
    cp pkgshare/"examples/tm1.hcl", testpath

    assert_match "Tower of London", shell_output("#{bin}/threatcl list #{testpath}/tm1.hcl")
    assert_match "Validated 2 threatmodels", shell_output("#{bin}/threatcl validate #{testpath}/tm1.hcl")
    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end
