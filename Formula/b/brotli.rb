class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/refs/tags/v1.2.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/brotli-1.2.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/brotli-1.2.1.tar.gz"
  sha256 "98d35d11a78dc453aebb7d10c3748f3f73ff78c8267c0dc697b8631f67bf7e8f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/google/brotli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fc57a4b7192e85eb81b440bfa786216f7cea407dd8d7bf93e17f886742b83ecd"
    sha256 cellar: :any, arm64_tahoe:       "a976542fe597e48a569a03f5a083405454f383995c657156979ef84b31c9e418"
    sha256 cellar: :any, arm64_sequoia:     "832894ee6c084c1ac212f6031518ec9e4d731ac372854f9cb8173da186114d13"
    sha256 cellar: :any, arm64_linux:       "8cfd9b38bae4952796e298c7856f4cf80f5b86d2e7412f10de8ab207f0a079ae"
    sha256 cellar: :any, x86_64_linux:      "18c72483cf18493596dbec9bc932c8e693203bd13084e18b24df0925fa594884"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build", "--verbose"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install buildpath.glob("build-static/*.a")
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system bin/"brotli", "file.txt", "file.txt.br"
    system bin/"brotli", "file.txt.br", "--output=out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
