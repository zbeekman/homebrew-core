class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://www.contentful.com/developers/docs/tutorials/cli/"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.12.tgz"
  sha256 "260451537b46b5340047dc88657780cbe831c0f2dafa9fd2ff428f6c7aed6c46"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f42e3c5d40fec07db04c2a40980920c5e03c1195fa7894d297c74ee952d421b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f42e3c5d40fec07db04c2a40980920c5e03c1195fa7894d297c74ee952d421b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f42e3c5d40fec07db04c2a40980920c5e03c1195fa7894d297c74ee952d421b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f4c65d3ebecbc3f3efd7a28b5a3ee1fe239d01a9568ca474f55631544c43f725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "705344eb9aeb2757561e5b260664269535290ebc5744111187b3ff1e5e43b876"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
