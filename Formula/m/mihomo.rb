class Mihomo < Formula
  desc "Another rule-based tunnel in Go, formerly known as ClashMeta"
  homepage "https://wiki.metacubex.one"
  url "https://github.com/MetaCubeX/mihomo/archive/refs/tags/v1.19.33.tar.gz"
  sha256 "e7c596b37ff27ec487d19b1920f73e0c97a78067ea35766530ee9659ade72711"
  license "GPL-3.0-or-later"
  head "https://github.com/MetaCubeX/mihomo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0047e43efa17fb071cf522e06f61816fbe9c9b494cd55834c64997107f13152f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1fb250ae1c77ba10d7b28c5860618d0edc8d4f0ee69ef526096070a490d7161"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57b4a06d60ae7d1a37a46df6c4fe4dc7ca802d854889ce76c86d863e3ff83eff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d59d263c441bff169e06876d86e7ce936c629ea6e9992f847bd13f6e2335deb"
    sha256 cellar: :any,                 x86_64_linux:      "157d080c2f340123f9987a57a23b540ef2ca9d74961f281dda98bb1cac85c41c"
  end

  depends_on "go" => :build

  # `test do` block binds a local port
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -buildid=
      -X "github.com/metacubex/mihomo/constant.Version=#{version}"
      -X "github.com/metacubex/mihomo/constant.BuildTime=#{time.iso8601}"
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "with_gvisor")

    (buildpath/"config.yaml").write <<~YAML
      # Document: https://wiki.metacubex.one/config/
      mixed-port: 7890
    YAML
    pkgetc.install "config.yaml"
  end

  def caveats
    <<~EOS
      You need to customize #{etc}/mihomo/config.yaml.
    EOS
  end

  service do
    run [opt_bin/"mihomo", "-d", etc/"mihomo"]
    keep_alive true
    working_dir etc/"mihomo"
    log_path var/"log/mihomo.log"
    error_log_path var/"log/mihomo.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mihomo -v")

    (testpath/"mihomo/config.yaml").write <<~YAML
      mixed-port: #{free_port}
    YAML
    system bin/"mihomo", "-t", "-d", testpath/"mihomo"
  end
end
