class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/refs/tags/0.64.1.tar.gz"
  sha256 "d2c3793bcc8edcf4e25f321617d3bc52132d20ec4ee7692cf73f94d3bedfc0b3"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "524cf77a7a47841ebfe01943a7421bfed0117b11b5a9ccc833a67e365900dfb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "871e56b300ad9ae1df9ef97a8297ccd921e976b9f0c3065dbffd13ce0972664c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97133daaee1ccbf7319848d2b5230f21cb63f0c0946cc908e04f516f51c8f44a"
    sha256 cellar: :any,                 arm64_linux:       "a69ac20335c16ecdda108a9db1a15ef5dfc69ff231e145f73a01dfdfd0a793fb"
    sha256 cellar: :any,                 x86_64_linux:      "cbdbf8894844230b749a20b2f883fee7e88085faf002e2f0aaf17cdd787bbba4"
  end

  uses_from_macos "swift" => :build

  deny_network_access!

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~SWIFT
      struct Potato {
        let baked: Bool
      }
    SWIFT
    system bin/"swiftformat", testpath/"potato.swift"
  end
end
