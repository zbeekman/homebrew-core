class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v0.98.0.tar.gz"
  sha256 "87a41581ab6b7796de796f6a99056f24931c1b7f47144541d0f868086dec4b78"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d8abf637f89f1c5ef911cacf5297cb3694950cff10c3f8a633affa2db06c0271"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c98c4fdd8e17c9a5aaf0cbc9f79850ec8941eb3dec50c3eca913c9aa73b4caa6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "803e264ff38ae5c3254dd16e4b1ac634e1922525c6329e98a59777503e0dc406"
    sha256 cellar: :any,                 arm64_linux:       "10cc78f3a15329580f7e82755f59589c36f003bdc7388a2b08cddfad5c535a80"
    sha256 cellar: :any,                 x86_64_linux:      "266c18708beb1690a3d2382839eb5c300e8365f838ccfacaeb7c7d08aeb4fb85"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access! :build

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Disable background auto-update by default
    inreplace "src/cli/args.rs",
              '#[arg(long, global = true, default_value = "true")]',
              '#[arg(long, global = true, default_value = "false")]'

    # Redirect `jcode update` to Homebrew
    inreplace "src/cli/dispatch.rs",
              "hot_exec::run_update()?;",
              'eprintln!("Please update jcode using: brew upgrade jcode");'

    system "cargo", "install", *std_cargo_args
    rm bin/"test_api"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jcode --version")
    assert_match "Please update jcode using: brew upgrade jcode", shell_output("#{bin}/jcode update 2>&1")

    system bin/"jcode-harness", "--cwd", testpath
    assert_match "alpha2", (testpath/"sample.txt").read
  end
end
