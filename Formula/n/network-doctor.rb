class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://github.com/heymaikol/network-doctor/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "c07b76f43623c528292cc6facbf51a8f512776d04ebd8aa80e45adb05c326527"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb91582efc68b4595b03b7c65446cd77a51d230de080dd2922b68643e4d1ac5b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb91582efc68b4595b03b7c65446cd77a51d230de080dd2922b68643e4d1ac5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb91582efc68b4595b03b7c65446cd77a51d230de080dd2922b68643e4d1ac5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "45a3500312d8854466be93452548955b0585444c2af85618050114de987fc53e"
    sha256 cellar: :any,                 x86_64_linux:      "22e005db478badaebbd1ce3ef08e33a84939ef35ba385580258837980ed70c8f"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"netdoc")
  end

  test do
    output = JSON.parse shell_output("#{bin}/netdoc -json")
    assert_equal version.to_s, output["version"]
    assert_equal true, output["checks"].any? { |hash| hash["id"] == "iface" && hash["status"] == "PASS" }
  end
end
