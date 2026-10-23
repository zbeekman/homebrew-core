class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://xplr.dev"
  url "https://github.com/sayanarijit/xplr/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "c33619255ba6af26d4bf4f1e12e6424140d37427134e0eaef3e1030b650c47f3"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3ef5099ea4d0943752c8be110e19e2bf4d27b4293fb5fe4debec50dfa8864780"
    sha256 cellar: :any, arm64_tahoe:       "7b300924f4afa751f88ebd730effb6980002927d1a5cff21c5db6cc6a49af876"
    sha256 cellar: :any, arm64_sequoia:     "ee17e8b115b3035b6e98f655752931396d5c3b7e1d24159a7265665dc783141c"
    sha256 cellar: :any, arm64_linux:       "73b65a58b95fc9b4395182f8b196575043587cf7bc2cbafe435b32686f590430"
    sha256 cellar: :any, x86_64_linux:      "22bcf55809518aa128002adead67f3b8397262d7790f864140df811258d55761"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "luajit"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utils/linkage"

    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end

    assert Utils.binary_linked_to_library?(bin/"xplr",
                                formula_opt_lib("luajit")/shared_library("libluajit")),
           "No linkage with libluajit! Cargo is likely using a vendored version."
  end
end
