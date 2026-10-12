class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/dlenski/vpn-slice.git", branch: "master"

  stable do
    url "https://files.pythonhosted.org/packages/74/fd/6c9472e8ed83695abace098d83ba0df4ea48e29e7b2f6c77ced73b9f7dce/vpn-slice-0.16.1.tar.gz"
    sha256 "28d02dd1b41210b270470350f28967320b3a34321d57cc9736f53d6121e9ceaa"

    # Backport commit to drop setuptools dep
    patch do
      url "https://github.com/dlenski/vpn-slice/commit/4e26adbfd14de2be5e77933e96d353ea7d200107.patch?full_index=1"
      sha256 "e80b63d2da61f47011d924fbcc48de9a7461c76a6cc977ee08fce99995bb155b"
      type :backport
      resolves "https://github.com/dlenski/vpn-slice/pull/149"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed684acb05d7f69954ceb535bb6cc5e9cc1f4c4a2836bbd4a57781e87af20ecb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ce45fcd3f9bed8b11fd2780ecf0ec7379c9ba89d8f79e692b0c71bb31dfde26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd141a705bff3a74746ba42047e6636530cd379ee7dbc3aab25977cd51a10e17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "414c174578e03c9f89b096e4cac861119b9e29fcb9e68b44d02ebd9e1d911be9"
    sha256 cellar: :any_skip_relocation, sonoma:            "78fbe63be8429f0ab38427d75dd2ed511a578f89f5019d5a775a7acb4cc2784a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8778f4daae86d96a51e7aed7efd2de7b556cc1dd1e41246855278da5622056d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e11db2b6fae77e64c63f5f9c3151a64d81a79db650bf5389e99dbeb406954734"
  end

  depends_on "rust" => :build # dnspython > uv_build
  depends_on "python@3.15"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ef/4a/50822184bd67cc6493f0fb6a880749158fcd31ab3fa07409acfd91f9fc85/dnspython-2.9.0.tar.gz"
    sha256 "b44dc6b18f07a8b1c56676a19fbfdb5209415b046a9cece286baafa87ff3f7f1"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/49/b0/6b8a516c5a9e9630bd5293db78314ac012f690305fe93beadea388626efb/setproctitle-1.3.8.tar.gz"
    sha256 "cafe209d064a6efb88cb45a03e97981ff8832802b2b5d009dde0197a3b7b41c8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # vpn-slice needs root/sudo credentials
    output = shell_output("#{bin}/vpn-slice 192.168.0.0/24 2>&1", 1)
    assert_match "Cannot read/write /etc/hosts", output
  end
end
