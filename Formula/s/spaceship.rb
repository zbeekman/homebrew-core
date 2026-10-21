class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh/"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/refs/tags/v4.22.6.tar.gz"
  sha256 "02da1413520241668141041f82284410dad5d3b4379a4d21b346ee206ee5f2be"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77ae5d1d7ce1fd543fb0af764655b671265b6af36aa0e7dba2f043bc15dafe88"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a646af652df5cc0f9b0a727a7b8ce00f315116171ae399f376b8892438676d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a646af652df5cc0f9b0a727a7b8ce00f315116171ae399f376b8892438676d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f11b7507cb3342fee0734cf0f74e8cafb8184d31a5d025c794ab47d22cf045c1"
    sha256 cellar: :any_skip_relocation, sonoma:            "1ab63848954d69c9a5692aaa49971e00fa6ef9b9cf546c577088f74acee1fff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "78271d687c2539835dd5cecb577c56430fe099337261598d1d58b36926cbcf7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "78271d687c2539835dd5cecb577c56430fe099337261598d1d58b36926cbcf7e"
  end

  depends_on "zsh-async"
  uses_from_macos "zsh" => :test

  def install
    system "make", "compile"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate Spaceship, add the following line to ~/.zshrc:
        source "#{opt_prefix}/spaceship.zsh"
      If your .zshrc sets ZSH_THEME, remove that line.
    EOS
  end

  test do
    # sourcing exits non-zero when `zcompile` cannot write beside the read-only keg, so check the prompt hook instead
    assert_match "SUCCESS",
      shell_output("zsh -fc '. #{opt_prefix}/spaceship.zsh 2>/dev/null; " \
                   "(( ${precmd_functions[(I)prompt_spaceship_precmd]} )) && echo SUCCESS'")
  end
end
