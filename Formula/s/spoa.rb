class Spoa < Formula
  desc "SIMD partial order alignment tool/library"
  homepage "https://github.com/rvaser/spoa"
  url "https://github.com/rvaser/spoa/archive/refs/tags/4.1.6.tar.gz"
  sha256 "5c69a2329456f9d7f611eccddf5cc8e85414a2f2ad23b539f77140919ba0da27"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "a0c6aad29ffdabee44691b95cdd038acdc05b21f0fa23728b4966252fb6546d1"
    sha256 cellar: :any, arm64_tahoe:       "c9fccbc0014b8c1f495ddc9073dd51f69d0a10aefc46e10b166311c1e4724d60"
    sha256 cellar: :any, arm64_sequoia:     "44cbe5908a4d582d75edf115868fadb1247b1f6111ca0f2974e50a1e74b5f440"
    sha256 cellar: :any, arm64_sonoma:      "749823a0c1e16ab05d1d916d45bfb74f9abda75bee68c6d6ae65955efb76bedb"
    sha256 cellar: :any, sonoma:            "f5773e569d8b1bb47043cff37f3dcde4d11e5142a28a7ffd8b8465d77e410583"
    sha256 cellar: :any, arm64_linux:       "caf94661a23225cae4a559cdd3867f368e62b5eb44af4fc05d256284cb05d0ef"
    sha256 cellar: :any, x86_64_linux:      "1185760cad8547073d91443bbe6965ac39a88fe8d9b04e6098d6d170d36809bd"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "bioparser" do
    url "https://github.com/rvaser/bioparser/archive/refs/tags/3.1.0.tar.gz"
    sha256 "ddb48cb456c72cf2955adf056c9204caf65483ec0a5bbba47389bc30ed9fdd05"
  end

  resource "biosoup" do
    url "https://github.com/rvaser/biosoup/archive/refs/tags/0.11.0.tar.gz"
    sha256 "e4addc3965ca9291535a131c07ef958a98e779ef1375d38d354536df66e16cd4"
  end

  deny_network_access!

  def install
    resources.each do |r|
      ENV.append_path "CMAKE_PREFIX_PATH", buildpath/"stage"
      r.stage do
        system "cmake", "-S", ".", "-B", "build",
                        "-D#{r.name}_build_tests=OFF",
                        *std_cmake_args(install_prefix: buildpath/"stage")
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
    end

    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -Dspoa_build_tests=OFF
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{rpath}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test/data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spoa --version")

    output = shell_output("#{bin}/spoa #{pkgshare}/data/sample.fastq.gz")
    assert_match ">Consensus", output
  end
end
