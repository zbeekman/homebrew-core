class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/88/f8/32a2a50137e3802475ed4f2e99c7db3e7e688f8d7d08ba68d342f91c37fe/linecast-2.10.3.tar.gz"
  sha256 "718b3e621641240cac1cc8ef09f26bf1dd85764dee4d7e185fdb062dab92eb7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1686413a9a801ebb1b269b7b68a4e706f53783150197ab1fe78a1666eea8836e"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/linecast --version")

    output = shell_output("#{bin}/linecast sunshine --location 43.657,-70.258 --json")
    assert_match '"schema": 1', output
    assert_match '"sunrise":', output
    assert_match '"sunset":', output
  end
end
