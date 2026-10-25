class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https://gomi.dev"
  url "https://github.com/babarot/gomi/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "850a09c2b738a1f831cb798ce308137d6ef4207d70544dbc6eaf3fddbfaf7b1a"
  license "MIT"
  head "https://github.com/babarot/gomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59415d3b3a927bf3ef0bc3d7f6de4d141f90a9366f40adf3ccd2370b12ba8049"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "59415d3b3a927bf3ef0bc3d7f6de4d141f90a9366f40adf3ccd2370b12ba8049"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59415d3b3a927bf3ef0bc3d7f6de4d141f90a9366f40adf3ccd2370b12ba8049"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "345da30b323c4e35cf22d2434f6eb1e151e11e7c4c972661b4f12f5b903fffff"
    sha256 cellar: :any,                 x86_64_linux:      "0ec18f170836766b35e31ac31916c1d641d1d8352c88e71207b7928a7f9c5124"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["TMPDIR"] = testpath

    # Create a trash directory
    mkdir ".gomi"

    assert_match version.to_s, shell_output("#{bin}/gomi --version")

    (testpath/"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath/"trash"
    system bin/"gomi", "trash"
    refute_path_exists testpath/"trash"
  end
end
