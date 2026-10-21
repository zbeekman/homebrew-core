class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v63.0.0.tar.gz"
  sha256 "7ef0b70117f0eead2d7b9270be1518448c416ee190675f97d73942532124eb75"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76248b928aa4d2fa31db0b7121678b625f1930a163a085fa6215c8e842f2e241"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f493035ca1372cb5619ab83a6998f11654f76e51651cebed65183f2e861f99c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb821a852bfb5463b898ff8ba7e5288546a7fbc55e054788f9795d4ebd2ebe48"
    sha256 cellar: :any,                 arm64_linux:       "fde36346ffaf40c184f93d169ab30174c6edcf48dbb8515eee350c467d5db38d"
    sha256 cellar: :any,                 x86_64_linux:      "03f3df79c9728534e9b63254bc1306df89e77a5be34dd92335754959a55c9364"
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
