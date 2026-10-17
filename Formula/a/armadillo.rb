class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.6.2.tar.xz"
  sha256 "63ee9351b54994dff7b4e2094a86ace48cfb41354cb65893a9dab7c8a16382c4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "821e030c3900578e37f0b84cc70cb1717b77acf4d0cefbbfb6d9feac263b5b07"
    sha256 cellar: :any, arm64_tahoe:       "6934af8b581da7a29d15acb654b2c35747bd59de11b30ead2b9164f87b216de6"
    sha256 cellar: :any, arm64_sequoia:     "bf1270b5d374c3621bdf416459080c10a0d5b388e8c1bf707f190ed12c02436b"
    sha256 cellar: :any, arm64_linux:       "f39aceba7334f02fff73b7fcf5fb850638d30534d5ecea9f2c3110927ea25db6"
    sha256 cellar: :any, x86_64_linux:      "78cd5c616611820bffaa52766180e78e664e886d611553b1829a08305b25dce5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "arpack"
  depends_on "openblas"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end
