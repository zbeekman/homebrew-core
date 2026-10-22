class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_12.2_build.tar.gz"
  sha256 "ade4fd6e277a10c82db4e75ff5acaeedb3113ef0c7d126ea2c8b38c37128f3c3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70f281725bc5340068fa6f39526d17cd7249cf990e950c00458ba53ff0a9020d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2a6222389d18d32d48e55079407c1d877d90f86d692911b0399a6ff5e440a9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fdaf330d5d9e3a2ad7c58c4cf69c6a145ec8a964c119617d6476f911434d6ca2"
    sha256 cellar: :any,                 arm64_linux:       "b8cca5890f3486247bcf94b329ed2558cf5277ced3de9055cbd59a9e27611321"
    sha256 cellar: :any,                 x86_64_linux:      "1808ba1b278316e6458c0cf8312dc421897f057cbbaf47c7ca3755360a3df121"
  end

  depends_on "gradle" => :build
  depends_on "python@3.15" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    inreplace "Ghidra/application.properties", "DEV", "PUBLIC" # Mark as a release
    system "gradle", "-I", "gradle/support/fetchDependencies.gradle"

    system "gradle", "buildNatives"
    system "gradle", "assembleAll"

    libexec.install (buildpath/"build/dist/ghidra_#{version}_PUBLIC").children
    (bin/"ghidraRun").write_env_script libexec/"ghidraRun",
                                       Language::Java.overridable_java_home_env("25")
    (bin/"pyghidraRun").write_env_script libexec/"support/pyghidraRun",
                                         Language::Java.overridable_java_home_env("25")

    # remove incompatible native binaries
    os = OS.mac? ? "mac" : "linux"
    arch = Hardware::CPU.arm? ? "arm_64" : "x86_64"
    (libexec/"GPL/DemanglerGnu/os").children
                                   .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}_#{arch}" }
    (libexec/"Ghidra/Features").glob("{Decompiler,FileFormats}/os/*")
                               .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    (testpath/"analyzeHeadless").write_env_script libexec/"support/analyzeHeadless",
                                                  Language::Java.overridable_java_home_env("25")
    (testpath/"project").mkpath
    system "/bin/bash", testpath/"analyzeHeadless", testpath/"project",
                        "HomebrewTest", "-import", "/bin/bash", "-noanalysis"
    assert_path_exists testpath/"project/HomebrewTest.rep"
  end
end
