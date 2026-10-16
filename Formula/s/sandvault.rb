class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "fa628973b568d2d27bece76706b2b08f59c84935caa96a7b51872bc63f11a0aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dfaada7c4cc1b005cab2bb52f0027e95d3c570d6f6b4a90660810944ad62a2ce"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  deny_network_access!

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone", "sv-agentsview-setup"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone", libexec/"sv-agentsview-setup"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
