class Apkid < Formula
  include Language::Python::Virtualenv

  desc "Android application identifier for compilers, packers, and obfuscators"
  homepage "https://github.com/rednaga/APKiD"
  url "https://files.pythonhosted.org/packages/f5/16/f354c98176e0e60e68ba5e8e4748063c43287d40482a6ccfd50acabd3c5f/apkid-3.2.0.tar.gz"
  sha256 "e812cf362672450f25941b3a38974c8e99d6e59e091d0a047ac05677c2b0d162"
  license "GPL-3.0-only"
  head "https://github.com/rednaga/APKiD.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "3a5c78eabbf3d544051d0396a3e120cbb01d88b272ae481bd1b6140b845b637e"
    sha256 arm64_tahoe:       "3c073aad9b3eb34cc7ee245cba568767531a528984a4354a2e8d711da2d120be"
    sha256 arm64_sequoia:     "d9917f0cea045f3ccda9a22ed81add45d6d5b8c17d384e4f06c68e3a5aeac61c"
    sha256 arm64_linux:       "55ce33c7b03a596b06d2769928665f7d81ac52b906dc1d09c8d514d668179c21"
    sha256 x86_64_linux:      "40df10352001ba9a89682fd0aaf47c8e53da4969db3465b453f7d25b682fb4a0"
  end

  depends_on "python@3.15"
  depends_on "yara"

  # `yara-python-dex` has no recent sdist; link `yara-python` to Homebrew's `yara`, which enables DEX
  pypi_packages exclude_packages: "yara-python-dex",
                extra_packages:   "yara-python"

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/51/38/347d1fcde4edabd338d5872ca5759ccfb95ff1cf5207dafded981fd08c4f/yara_python-4.5.4.tar.gz"
    sha256 "4c682170f3d5cb3a73aa1bd0dc9ab1c0957437b937b7a83ff6d7ffd366415b9c"
  end

  # The PyPI sdist only ships `rules.yarc` compiled with YARA 3.x, so rebuild it from the rule sources
  resource "apkid-rules" do
    url "https://github.com/rednaga/APKiD/archive/refs/tags/v3.2.0.tar.gz"
    sha256 "7898ef35dcbd367fe6d4311478ce133ca81cb861c0e8a111c00f2d5f3c88f57d"

    livecheck do
      formula :parent
    end
  end

  allow_network_access! :build

  def install
    venv = virtualenv_install_with_resources without: %w[apkid-rules yara-python]

    resource("yara-python").stage do
      inreplace "setup.py", "self.dynamic_linking = None", "self.dynamic_linking = True"
      venv.pip_install Pathname.pwd
    end

    rules = venv.site_packages/"apkid/rules"
    resource("apkid-rules").stage { rules.install Dir["apkid/rules/*"] }
    system libexec/"bin/python", "-c", <<~PYTHON, rules
      import sys
      from apkid.rules import RulesManager
      manager = RulesManager(sys.argv[1])
      manager.compile()
      manager.save()
    PYTHON
  end

  test do
    apk = testpath/"test.apk"
    system python3, "-c", <<~PYTHON, apk
      import sys
      import zipfile
      with zipfile.ZipFile(sys.argv[1], "w") as archive:
          archive.writestr("AndroidManifest.xml", "manifest")
          archive.writestr("assets/AndroidManifest.xml", "manifest")
    PYTHON

    output = shell_output("#{bin}/apkid --json #{apk}")
    assert_match "apkid_version", output

    yara_rule = testpath/"test.yara"
    yara_rule.write <<~YARA
      import "dex"

      rule test {
        strings:
          $a = "marker"
        condition:
          $a
      }
    YARA
    result = shell_output(
      "#{libexec}/bin/python -c 'import sys, yara; " \
      "print(yara.compile(filepath=sys.argv[1]).match(data=\"marker\")[0].rule)' #{yara_rule}",
    )
    assert_equal "test", result.strip
  end
end
