class Tclap < Formula
  desc "Templatized C++ command-line parser library"
  homepage "https://tclap.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tclap/v1.4.0/tclap-1.4.0.tar.gz"
  sha256 "413014a7e68740d9aa972a058532e3e9959b4af7509d6ae7b11a8c1828378567"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/tclap[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1067d4df91f61b3a6af2efd80c62b4359cc7f1f9088892ad9443d13be791bc0a"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_EXAMPLES=OFF
      -DBUILD_DOC=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Based on https://sourceforge.net/p/tclap/code/ci/1.4/tree/examples/test1.cpp
    (testpath/"test.cpp").write <<~CPP
      #include <string>
      #include <iostream>
      #include <algorithm>
      #include "tclap/CmdLine.h"

      using namespace TCLAP;
      using namespace std;

      int main(int argc, char** argv) {
        CmdLine cmd("Command description message", ' ', "0.9");
        ValueArg<string> nameArg("n", "name", "Name to print", true, "homer", "string");
        cmd.add(nameArg);
        SwitchArg reverseSwitch("r", "reverse", "Print name backwards", false);
        cmd.add(reverseSwitch);
        cmd.parse(argc, argv);
        string name = nameArg.getValue();
        bool reverseName = reverseSwitch.getValue();
        if (reverseName) {
          reverse(name.begin(), name.end());
        }
        cout << name;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test"
    assert_equal "werbemoH", shell_output("./test -r -n Homebrew")
  end
end
