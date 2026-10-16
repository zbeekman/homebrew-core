class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/f5/e8/303e333a45289c2f1f006661c9aa535de83b316a6bfc2d2f97ba815be143/ty-0.0.88.tar.gz"
  sha256 "5e3165a05b3757edd5a08b1fc6cb4a00c3b067100416d50afb2d13a5ec102206"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "18c2b1fc1d44d08498bca53a051854b55b9a889833e0173373441366599e8025"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0fef99bc084a8fd66fa83a09a4597a9b8ab5c467caaeb924d97fd06e7048644c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a42c1b27c687f207cc28ab19c6089ae62de56c1252c783ae533e51012ca849f1"
    sha256 cellar: :any,                 arm64_linux:       "1f826f2253432ab6f0612e39d03c305a0f2f9cd98e0afff8019d21dc9f724902"
    sha256 cellar: :any,                 x86_64_linux:      "7fd5d29c0eed451ce9d4d0edc0226a79286407cecde0704ffb4bfd9cc518c2ca"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # The sdist prunes some `ruff` workspace members but ships the full repo
    # Cargo.lock, so `cargo fetch --locked` would refuse to shrink it.
    system "cargo", "fetch", "--target", "host-tuple", "--manifest-path", "ruff/Cargo.toml"
  end

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    ENV["TY_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PYTHON
      def f(x: int) -> str:
          return x
    PYTHON

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end
