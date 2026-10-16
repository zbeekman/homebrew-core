class WebExt < Formula
  desc "Command-line tool to help build, run, and test web extensions"
  homepage "https://github.com/mozilla/web-ext"
  url "https://registry.npmjs.org/web-ext/-/web-ext-10.8.0.tgz"
  sha256 "8fa96813b3830c4f40984fd4111c1db39c9bb62b5b48252ec9fcaa20de2df203"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4024c05b6b77475fd3a6f8f18d1f2b70df4b59de09e79ef05ba2656a6ee22de2"
  end

  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"manifest.json").write <<~JSON
      {
        "manifest_version": 2,
        "name": "minimal web extension",
        "version": "0.0.1"
      }
    JSON
    assert_match <<~EOF, shell_output("#{bin}/web-ext lint").gsub(/ +$/, "")
      Validation Summary:

      errors          0
      notices         0
      warnings        2

    EOF

    assert_match version.to_s, shell_output("#{bin}/web-ext --version")
  end
end
