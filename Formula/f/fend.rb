class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.5.9.tar.gz"
  sha256 "3622b09d197d4be374880f3f97256633d0481e7a3c7da2f69f2cb5141aac1721"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e198b7422c3fa7d29fe81cfcf5217ccc16cb1d913e847cbe19b556ce4e1995d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f42544ef852d93cb0d6b129db48884bb910271f507c06facad44a6cd76e5c47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c7cbd81d7a5db05284f968efc13bff3007c7bfb8748d29a02a8fb1e54bd94a1"
    sha256 cellar: :any,                 arm64_linux:       "29cd91e3028114059d6349b1a32fd89b379bc8df27489862ad1d618e76ec912c"
    sha256 cellar: :any,                 x86_64_linux:      "ae6633345d519c769157e0bbb85dc8f541e42a786e034e7eb80e8e1e26836958"
  end

  depends_on "pandoc" => :build
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
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli", features: "native-tls")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
