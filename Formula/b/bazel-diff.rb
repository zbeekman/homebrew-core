class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v61.0.0.tar.gz"
  sha256 "d34f8c3c8c168062fa8f5b0a2902cc08916206e265fcf7cbd3f40d98451796b6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26cc4e51b7f2f169e8a9d359dcec915dc60fb4cbfdd6344f32a1aa3bc8be16ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c371b0799b4291e5f39ac0559df471d4da963e43e312ed2b127c9188ddd633d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c403e5b9098eed7596f1a4f197abb48cf854cd0ac29cb1c85ff79f565e632764"
    sha256 cellar: :any,                 arm64_linux:       "4270c63041d0b86f32b81da197928ddcd774bc9f08ce84bd58309ac53aa94549"
    sha256 cellar: :any,                 x86_64_linux:      "211a066e9c2e007ef3b518a416351199c8391f1eb730f0f850a56f4ca295399b"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Use our protoc rather than the prebuilt one from `protoc-bin-vendored`
    ENV["PROTOC"] = formula_opt_bin("protobuf")/"protoc"
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"from.json").write <<~JSON
      {"//app:leaf": "Rule#old~old", "//app:top": "Rule#top~same"}
    JSON
    (testpath/"to.json").write <<~JSON
      {"//app:leaf": "Rule#new~new", "//app:top": "Rule#top~same"}
    JSON

    output = shell_output("#{bin}/bazel-diff get-impacted-targets --startingHashes from.json " \
                          "--finalHashes to.json --workspacePath #{testpath}")
    assert_equal "//app:leaf\n", output
  end
end
