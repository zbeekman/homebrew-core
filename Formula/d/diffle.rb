class Diffle < Formula
  desc "Keyboard-first diff viewer with LSP support and GitHub integration"
  homepage "https://github.com/moritzwilksch/diffle"
  url "https://registry.npmjs.org/@moritzwilksch/diffle/-/diffle-0.2.6.tgz"
  sha256 "5e8e917751e2a1d76d1e07ce00840dab5f2216ac3817c9cc31eecbb9457cc270"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0fcfeed6ed3eab2d31ab0eac077404ef7656681defa0d7aec7481bd7f0c9753e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffle --version")

    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    (testpath/"hello.txt").write "hello\n"
    system "git", "add", "hello.txt"
    system "git", "commit", "-m", "initial"
    (testpath/"hello.txt").append_lines "world"

    port = free_port
    pid = spawn bin/"diffle", "working", "--port", port.to_s, "--no-open", "--no-lsp", "--no-watch", "--keep-alive"
    begin
      sleep 5
      assert_match "<html", shell_output("curl -s http://127.0.0.1:#{port}/")
      assert_match "+world", shell_output("curl -s http://127.0.0.1:#{port}/api/patch")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
