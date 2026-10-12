class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "76b9731fe75b3a2d3e39acc695c7fa16b74c7aff4744f6afcc5cf2c9b529ed60"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99d04fed39d7889a17b0ee21748d779c165a5fb8ccf65f23371418282bb7e58d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a02308527400c729835acbd699d8f308caf16771a42c355511e31a53a663bcbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0f80e4bff794b0bc7f3c6825aceae9daa941835e03acf787388e09ee9f6c3f8"
    sha256 cellar: :any,                 arm64_linux:       "c9f52015d9755b2cd60c18ece63931de7d04af5590cb831277b8c9ba164d0938"
    sha256 cellar: :any,                 x86_64_linux:      "f326e354165a2e7b295773f7417b773e1cd8b28580a582f2ed896e0da4d16bd3"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
