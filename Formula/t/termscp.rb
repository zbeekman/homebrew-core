class Termscp < Formula
  desc "Feature rich terminal file transfer and explorer"
  # https://termscp.veeso.dev is not accessible, upstream bug report, https://github.com/veeso/termscp/issues/420
  homepage "https://termscp.rs"
  url "https://github.com/veeso/termscp/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "378b06607669edd6fdbcf1f3e040928b4a5e41c3792334d8b140270bd9afe0b7"
  license "MIT"
  head "https://github.com/veeso/termscp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3fb5b68947658bbdd0f71fee51e6b32a2aaf4c4c6851c1263ef9832cbbd310e7"
    sha256 cellar: :any, arm64_tahoe:       "0d0bc958f563ad79d39080919e9cd0ecfb09df0c93d947a14d7e140b6318b4a2"
    sha256 cellar: :any, arm64_sequoia:     "0f7da68db6c8eb443e0cea7724433989b68450e1d086c4d5056ef3fe3aeebeac"
    sha256 cellar: :any, arm64_linux:       "5e2a5870b91a6a163cf73b4d160203247fe94a1bf222f4223ab28c75d0010bd4"
    sha256 cellar: :any, x86_64_linux:      "39969dd4ba6017b3372a2717cc26a737f3c4fc4e69fc01b4a9795640dfa0b619"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
  depends_on "samba"

  on_linux do
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    PTY.spawn(bin/"termscp", "config") do |_r, _w, pid|
      sleep 10
      Process.kill 9, pid
    end
  end
end
