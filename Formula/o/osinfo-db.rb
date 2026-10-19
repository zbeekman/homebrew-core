class OsinfoDb < Formula
  desc "Osinfo database of operating systems for virtualization provisioning tools"
  homepage "https://libosinfo.org/"
  url "https://gitlab.com/libosinfo/osinfo-db/-/releases/v20260812/downloads/osinfo-db-20260812.tar.xz", using: :nounzip
  sha256 "f13ed6e1e480b5266d39cad7f0010febdf0265dfc45579de2fb34543bc6b35de"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://gitlab.com/libosinfo/osinfo-db.git"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "26a46e573f1927bb33a3b0124ee80a9461519af1b7cbbf8e2b0a923b4c787f30"
  end

  depends_on "osinfo-db-tools" => [:build, :test]

  def install
    system "osinfo-db-import", "--dir=#{share}/osinfo", "osinfo-db-#{version}.tar.xz"
  end

  test do
    system "osinfo-db-validate", "--system"
  end
end
