class Lunarr < Formula
  desc "Self-hosted media streaming server and Plex alternative for movies and TV"
  homepage "https://github.com/lunarr-app/lunarr-go"
  url "https://github.com/lunarr-app/lunarr-go/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "e1d0317e8217d8a880e7b9eb340172dd6239854ca224bd845862e777ce6628c7"
  license "Apache-2.0"
  head "https://github.com/lunarr-app/lunarr-go.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "53317b1d617acca892fb46a24adfa8ce85960f1fd66a85395c38195bcdfe7ca8"
    sha256 cellar: :any, arm64_tahoe:       "3e4b112b6a344d508977a70b97541181128bd49f06ba45ca4a4e12a741721da4"
    sha256 cellar: :any, arm64_sequoia:     "1b094b8872d1e1ffe33a83725e6f00a765c18790a9e65a932da32fa39ee20b8a"
    sha256 cellar: :any, arm64_linux:       "598a67ea9d4c4d237a8719306b2a30dd3dfcbb185b09c5afd9803c02109b58f9"
    sha256 cellar: :any, x86_64_linux:      "e30fcc34d3135f53a47b9e5db359f218753b1e383343c6093cc4072d5064408f"
  end

  depends_on "ffmpeg"
  depends_on "node"

  # `better-auth` needs its exact `@better-auth/core`; npm otherwise resolves a newer one with mismatched peers
  resource "better-auth-core" do
    url "https://registry.npmjs.org/@better-auth/core/-/core-1.7.11.tgz"
    sha256 "ec150a0c7fee44737af5e5bf72dfcf1e80e2c863a8ec06445c7f8e4dd2c167b6"

    livecheck do
      url "https://raw.githubusercontent.com/lunarr-app/lunarr-go/refs/tags/v#{LATEST_VERSION}/package.json"
      regex(/(\d+(?:\.\d+)+)/)
      strategy :json do |json, regex|
        json.dig("dependencies", "better-auth")&.[](regex, 1)
      end
    end
  end

  def install
    system "npm", "install", *std_npm_args(prefix: false), *resources.map(&:cached_download)
    system "npm", "run", "build"
    system "npm", "prune", "--omit=dev"

    # strip the foreign slice of the universal binary to satisfy `brew audit`
    deuniversalize_machos "node_modules/fsevents/fsevents.node" if OS.mac?

    # keep only the prebuilt native libraries matching this platform;
    # @libsql suffixes the libc (`darwin-arm64`, `linux-arm64-gnu`) while
    # @seydx/node-av prefixes the package name (`node-av-darwin-arm64`)
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os_arch = OS.mac? ? "darwin-#{arch}" : "linux-#{arch}"
    Dir["node_modules/@{libsql,seydx}/*"].each do |dir|
      base = File.basename(dir)
      rm_r(dir) unless base.end_with?(os_arch, "#{os_arch}-gnu")
    end

    libexec.install Dir["*"]
    (bin/"lunarr").write_env_script formula_opt_bin("node")/"node", libexec/"scripts/start.mjs",
                                    NODE_ENV:    "production",
                                    FFMPEG_PATH: formula_opt_bin("ffmpeg")/"ffmpeg"
  end

  service do
    run [opt_bin/"lunarr"]
    keep_alive true
    environment_variables LUNARR_DATA_DIR: var/"lunarr"
    log_path var/"log/lunarr.log"
    error_log_path var/"log/lunarr.log"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lunarr --version").strip

    port = free_port
    ENV["LUNARR_DATA_DIR"] = (testpath/"data").to_s
    ENV["PORT"] = port.to_s
    pid = spawn bin/"lunarr"
    begin
      output = shell_output("curl --silent --retry 10 --retry-connrefused --retry-delay 3 " \
                            "http://127.0.0.1:#{port}/api/health")
      assert_match "\"ok\":true", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
