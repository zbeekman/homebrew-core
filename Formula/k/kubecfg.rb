class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "12a73a30ee523e3e4254ab592e02066110068bbd93df792d16dda20ba8087183"
  license "Apache-2.0"
  head "https://github.com/kubecfg/kubecfg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c20e88c4772fd7a421cb4a096baaff84283ec073b0005cb356422c49107dfd9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "beb47afaa94888cc833062cb90483c6000644253848720ddf4477378cf9f5588"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "80193a48720c06508579a931b5246a521e039cd4cc4e60ad16482b95f0a5b167"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c15e4782868829c873c4ce2004a6db4525fe473660011f47572e2c01ea7f067f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b59824ed84c5cb5728c2c0bb6defd3a74809e29aad94c28015aa7e9bdaf7ca61"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "VERSION=v#{version}"
    bin.install "kubecfg"
    pkgshare.install Pathname("examples").children
    pkgshare.install Pathname("testdata").children

    generate_completions_from_executable(bin/"kubecfg", "completion", "--shell")
  end

  test do
    system bin/"kubecfg", "show", "--alpha", pkgshare/"kubecfg_test.jsonnet"
  end
end
