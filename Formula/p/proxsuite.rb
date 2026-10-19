class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://github.com/Simple-Robotics/proxsuite/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "b9b05f29d30f69cf90853ae1f7015914b5e371a6dac6aa46630aaa090447c578"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "devel"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "ac0f9e0e38e27c9a5cf185dfcdde783c6d8702ada5a763724c5b89f16e7e2a74"
    sha256 cellar: :any, arm64_tahoe:       "c785322d10144d0ef53903773a531d1a80690275a34c5971f35316ecfc6a9c6b"
    sha256 cellar: :any, arm64_sequoia:     "845d275a4c9e480f5f5fab44d2da69fa0128c44878fb0a3f72ec3cab91ef3fe7"
    sha256 cellar: :any, arm64_linux:       "9eac14d08c8fd0b1ce5c497c3702e4af2e9afc54716d75964077e3af150f5cc4"
    sha256 cellar: :any, x86_64_linux:      "8787ca950ebbd54aeeb67e03325758f94934c7a830750733bb2c6d93698452af"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "nanobind" => :build
  depends_on "pkgconf" => :build
  depends_on "cereal" => :no_linkage
  depends_on "eigen" => :no_linkage
  depends_on "numpy" => :no_linkage
  depends_on "python@3.15"
  depends_on "scipy" => :no_linkage
  depends_on "simde" => :no_linkage

  resource "jrl-cmakemodules" do
    url "https://github.com/jrl-umi3218/jrl-cmakemodules/archive/refs/tags/v2.3.0.tar.gz"
    sha256 "840cfba922b9589695ee3da4da3f9472ceeefe8fe4bccbb7ed3e885d1ca978cf"
  end

  deny_network_access!

  def install
    resource("jrl-cmakemodules").stage buildpath/"jrl-cmakemodules"

    # Workaround to fix error: a template argument list is expected after
    # a name prefixed by the template keyword [-Wmissing-template-arg-list-after-template-kw]
    if DevelopmentTools.clang_build_version >= 1700
      ENV.append_to_cflags "-Wno-missing-template-arg-list-after-template-kw"
    end

    args = %W[
      -DPYTHON_EXECUTABLE=#{python3}
      -DBUILD_UNIT_TESTS=OFF
      -DBUILD_PYTHON_INTERFACE=ON
      -DINSTALL_DOCUMENTATION=ON
      -DJRL_CMAKEMODULES_SOURCE_DIR=#{buildpath}/jrl-cmakemodules
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    PYTHON
  end
end
