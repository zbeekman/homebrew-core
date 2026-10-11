class Roadrunner < Formula
  desc "High-performance PHP application server, load-balancer and process manager"
  homepage "https://docs.roadrunner.dev/docs"
  url "https://github.com/roadrunner-server/roadrunner/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "bf687e6ae9b544ef51db550a7d7588b4f35fa6e04de768c5e115d36f974030a5"
  license "MIT"
  version_scheme 1
  head "https://github.com/roadrunner-server/roadrunner.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d{1,3}(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f4812e61be40a36da86872f4fe19f7210e0831ea077cbda2813d44f76bee94d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "45a1a323ca350dea2736e7a9c8c4840f724545ecf179aa7137aa99832fc6c855"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb25b20629baf38bf0332e1b1962c9aa71bfd361ba2348fdf2ec5f2102c6b7c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b3167204d78938002b98b70d5437e9fcb592ae28715954512604a496d2ed978f"
    sha256 cellar: :any_skip_relocation, sonoma:            "3ff7ce8adafafab4c387fc8c8cdeba7648e77af3108ec118b380234731c7fb5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6c625c486f0ec39336c89a7b4a8dd737217b9298a215edeb3b11b8c5adcd2d2a"
    sha256 cellar: :any,                 x86_64_linux:      "8fc3ac95875cf31f395c407c3406beb22b9f5f45dee7c71519c928518e281a3e"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.version=#{version}
      -X github.com/roadrunner-server/roadrunner/v#{version.major}/internal/meta.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"rr"), "./cmd/rr"

    generate_completions_from_executable(bin/"rr", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    (testpath/".rr.yaml").write <<~YAML
      # RR configuration version
      version: '3'
      rpc:
        listen: tcp://127.0.0.1:#{port}
    YAML

    output = shell_output("#{bin}/rr jobs list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/rr --version")
  end
end
