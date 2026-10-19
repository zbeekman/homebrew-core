class SemCli < Formula
  desc "Semantic version control CLI with entity-level diffs and blame"
  homepage "https://ataraxy-labs.github.io/sem/"
  url "https://github.com/Ataraxy-Labs/sem/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "690ae799e305f3cc79b81cd5733bff125b0b9e7944de4ce820abc155fd9ece49"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Ataraxy-Labs/sem.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ae651db32e7af0ffd6221ac165163218f9df848b12c2efb10afe006d668db273"
    sha256 cellar: :any, arm64_tahoe:       "bc55730bb91ca5a9f5d8fa0bf54760da212f03d30f358cfad1ea5c430a69cce6"
    sha256 cellar: :any, arm64_sequoia:     "17703be4d7f552e77d1c39a708974ab5e61d15ad6d2f4fa640ea41866c65bafa"
    sha256 cellar: :any, arm64_linux:       "c0467432b222818331e0382722a29206426a487d16dee82be18f1ec2a416a256"
    sha256 cellar: :any, x86_64_linux:      "cbbb57cd06a39c37e1e31d2685947e9a4a6d125ec098562e1cf2125ddfa9ed72"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "crates/sem-cli/Cargo.toml"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sem-cli")
  end

  test do
    assert_match "sem #{version}", shell_output("#{bin}/sem --version")

    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")
    PYTHON
    system "git", "init"
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "init"

    inreplace "hello.py", "hello", "hello world"
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "update"

    output = shell_output("#{bin}/sem diff --commit HEAD --format json")
    json = JSON.parse(output)
    assert_equal 1, json["changes"].length
    assert_equal "function", json["changes"][0]["entityType"]
    assert_equal "greet", json["changes"][0]["entityName"]
  end
end
