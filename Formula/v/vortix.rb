class Vortix < Formula
  desc "Terminal UI for WireGuard and OpenVPN with live telemetry and leak guarding"
  homepage "https://github.com/Harry-kp/vortix"
  url "https://github.com/Harry-kp/vortix/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "2ad10a08225b9eb7069234f41aa3f719d7cc8fbaae6202cc3f34250ab74f1da2"
  license "MIT"
  head "https://github.com/Harry-kp/vortix.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5607c554ac0bc07f0bf5aa20de810ddce10bfd01bd0fd7334fa9b746434c3b14"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "865466e241e74df3f2104c58db2c078bd5a1707ab2468ea730d1a8a51ff2815c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc78fd0ffbf3265fd9a8e59560b4b819fd4c088a3682725a06cc19d42651aa47"
    sha256 cellar: :any,                 arm64_linux:       "4e7b3106451dfc3aa2e47b832dbfb8ceb29fb0092965b54413f000b8d5caa602"
    sha256 cellar: :any,                 x86_64_linux:      "db71586dba103c4e3ccff5529fe503f5b7b730b3f15720acd74181fa9f565c97"
  end

  depends_on "rust" => :build
  depends_on "openvpn"
  depends_on "wireguard-tools"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/vortix")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vortix --version")
    # Mode names are checked before the root check, so this runs unprivileged.
    assert_match "off, block-on-drop, vpn-only", shell_output("#{bin}/vortix killswitch auto 2>&1", 1)
  end
end
