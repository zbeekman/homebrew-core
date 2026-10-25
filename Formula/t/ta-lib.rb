class TaLib < Formula
  desc "Tools for market analysis"
  homepage "https://ta-lib.org/"
  url "https://github.com/ta-lib/ta-lib/releases/download/v0.8.3/ta-lib-0.8.3-src.tar.gz"
  sha256 "28b1179b178a0db15f3dad0d846ef77f18eb06db5dfc5b5a8ca153a9ea5d84e6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "537ead5f8cd09b4cc0f3ed3a66a3736cc925e1a234064a1f563b3c5c6a0350dc"
    sha256 cellar: :any, arm64_tahoe:       "e6de6d178938c85fdcc0f2717376cd484dc176c5f24db4c64b4260e83318c9e0"
    sha256 cellar: :any, arm64_sequoia:     "b6f40477c526a50e488e3148bf9c1e291a2f4c38dd61722c0222c060b9ce0be3"
    sha256 cellar: :any, arm64_linux:       "308662968647f28aae04f83313dc7dd6fadfe5dfca8051b46946c4ba9601b9a0"
    sha256 cellar: :any, x86_64_linux:      "cabd2109c3726727400f5182715def1b8def16c351aa4429fcfc06dd965c34d5"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    ENV.deparallelize
    # Call autoreconf on macOS to fix -flat_namespace usage
    system "autoreconf", "--force", "--install", "--verbose" if OS.mac?
    system "./configure", *std_configure_args
    system "make", "install"
    bin.install "src/tools/ta_regtest/.libs/ta_regtest"
  end

  test do
    system bin/"ta_regtest"
  end
end
