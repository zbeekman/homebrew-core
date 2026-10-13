class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.1.1.tgz"
  sha256 "c05b3cff890d35e1208805a01fd0501571d09a81e725de0559b10bdfae90adad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe45172ba64b3b3f978f09d3032b3690cfcd3f1704390db889892c180d07ecd2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", shell_output("#{bin}/marked -s 'hello *world*'").strip
  end
end
