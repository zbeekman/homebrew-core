class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://www.oneapi.io/open-source/"
  url "https://github.com/uxlfoundation/oneDNN/archive/refs/tags/v3.14.tar.gz"
  sha256 "063eca4137678ba79b2da7030cbe2b41b1cc7b15a76ac13728a531a710e7392d"
  license "Apache-2.0"
  head "https://github.com/uxlfoundation/oneDNN.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "601663f3b54af97045ce5dca5a50b5f983fc1f7135161ce2d851798898c1211b"
    sha256 cellar: :any, arm64_tahoe:       "0b9d6460e1c08ae1716de8c38786ae4a60b55d1235232293001bf414a254903a"
    sha256 cellar: :any, arm64_sequoia:     "4811fd76f07228228b3ab844d19d06059d23593b43a9f4211cebd9bca66d28a0"
    sha256 cellar: :any, arm64_linux:       "efcab2205946722936a17e6cbb5a3c7c9587a3ae2ab33b7db175807daf4d5e8f"
    sha256 cellar: :any, x86_64_linux:      "3d67ce913cd87f6d57939f8fa666c6d353124901187a95976af3e9115019b16f"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    # Keep KleidiAI's per-target `-march=...+fp16/+sve/+sme` flags; kernels are selected at runtime
    ENV.runtime_cpu_detection if Hardware::CPU.arm?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <oneapi/dnnl/dnnl.h>
      int main() {
        dnnl_engine_t engine;
        dnnl_status_t status = dnnl_engine_create(&engine, dnnl_cpu, 0);
        return !(status == dnnl_success);
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-ldnnl", "-o", "test"
    system "./test"
  end
end
