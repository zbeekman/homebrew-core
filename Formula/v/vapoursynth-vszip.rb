class VapoursynthVszip < Formula
  desc "VapourSynth Zig Image Process"
  homepage "https://github.com/dnjulek/vapoursynth-zip"
  url "https://files.pythonhosted.org/packages/ac/5b/46cc32a9236271e709904c88056f053a731973c7358f4be44830aa242c9f/vapoursynth_vszip-23.0.0.tar.gz"
  sha256 "7ef229ccbe9484a9a7b4b28f0535bcdc10e2e51386c9ba085f49f3134d2e85f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dddfa06563a0c12bd158063bf6a8c5bc81761f2a5af6f649f1de073601e5420a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5b0241efb4b15eaa961932306d985fae2a86bc3aaeff159776310de1f0d6930"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "845006e5771a2c76e7dc91bcd5720006bbfc8188786a643f7a4d5db097a2232d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4ac5fc970fc22067131ef1512d6a496102b35a0cc01f672914b9ec61257d70a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5cdc4a3deac4aaff6e38fac617eae0a5513bec603cedd4610021def0071848a3"
  end

  depends_on "zig" => :build
  depends_on "python@3.15"
  depends_on "vapoursynth"

  preserve_rpath # skip unnecessary relocation for plugin which avoids headerpad errors

  pypi_packages exclude_packages: "vapoursynth"

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    plugindir = "#{Language::Python.site_packages(python3)}/vapoursynth/plugins"
    system "zig", "build", "--prefix-lib-dir", plugindir, *std_zig_args
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from vapoursynth import core
      print(core.vszip.ImageRead("#{test_fixtures("test.png")}"))
    PYTHON
    assert_match "Width: 8", shell_output("#{python3} test.py")
  end
end
