class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "993b39e3085c9b53556af0e8297859c36ef1a5aeebf51378dabde49479ec1b7d"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d0e2d555e79664fac01a85744fe85d8883f0b5c0902058b893300105c6237f75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d0e2d555e79664fac01a85744fe85d8883f0b5c0902058b893300105c6237f75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0e2d555e79664fac01a85744fe85d8883f0b5c0902058b893300105c6237f75"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0920d67e80fd996ea86c9d0eb483bc722afa0bdd7bfb3a84f9456a12c6c6b4b6"
    sha256 cellar: :any,                 x86_64_linux:      "de34cc84f8978219d35a383f1732a2905e8410548db10f52102e8778d05d0f93"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"wgcf", shell_parameter_format: :cobra)
  end

  test do
    system bin/"wgcf", "trace"
  end
end
