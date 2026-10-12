class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "d8796325dad02802dccc91568a90a00e43247cad1d87ddbd9779a99d3c435d61"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fab0af400c1bffce6a7384ca56a3fe352c891798a5094910fc0155121822bccc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eb204a0aae3973582352fd6890c02e99b106bc1cf766716af5dd8fe70f3711fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "089b9d69d4a5270fadf98a968c6fcd66bdd0e38aaea45bcd8e15f03998162bed"
    sha256 cellar: :any,                 arm64_linux:       "607d1f280d570d441f9dd89d9bfe44809776f5476f5d2a37283c9655e2db3fed"
    sha256 cellar: :any,                 x86_64_linux:      "b15bd0b5623d75ce8820d6f7041e0b466ab56f9404b76ba4f4dafdaeaa195dfc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "gleam-bin")
  end

  test do
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
