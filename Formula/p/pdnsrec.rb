class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.4.8.tar.xz"
  sha256 "bb2fac755c3c301b6e1b9892e94ccdc652752f2bf88ec970e9358056973fe9bd"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "6f75a61973dffa5d475d34c96453e57b8a92e6b8f45d23260006f1b833788e4f"
    sha256 arm64_tahoe:       "6be0b40711d76356d4456e8691f93e3cc937a6ddef57f7fc55c25866fc4a3629"
    sha256 arm64_sequoia:     "a2fa6071fee7a330dbc01b1f76cd630a8818a8ca11b7e265a96c85983b106701"
    sha256 arm64_linux:       "5ca129d6bcaa3f7377dfd605e3b032bdc14982142647f7cd64f20c28178151da"
    sha256 x86_64_linux:      "873596e213de53513c9ad3f31fedf34597a8b31193ff118ebe1356aa4031014d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@4"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  def install
    args = %W[
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{formula_opt_prefix("boost")}
      --with-libcrypto=#{formula_opt_prefix("openssl@4")}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
