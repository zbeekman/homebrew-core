class GiteaRunner < Formula
  desc "Official Actions runner for Gitea"
  homepage "https://gitea.com/gitea/runner"
  url "https://gitea.com/gitea/runner/archive/v5.2.0.tar.gz"
  sha256 "ebf3f24bad167b0e70af9a60b8e8d2fa343b59b588033c3a7040024117f22775"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e005119d2c864e9de2511bcbc3f67498833218209c2994bacf4850ef5c4ce3a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad810014cb3cb0b279ef1d54f33d512f14e4680e4bb3b64eaa13e2f8893e7819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1a4d554d3cc3a867b22db3a72d766a441dda7983a7d377f8d6e55b4e6900a6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4be28ec750970e98c071dd6bc7412cfeb43595ccdbe3f3531d4827b92e496b71"
    sha256 cellar: :any,                 x86_64_linux:      "d222a472199211a170d310f795143ae1d09ad8f14a70c5a3e9984298fcdbd758"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X gitea.com/gitea/runner/internal/pkg/ver.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gitea-runner", shell_parameter_format: :cobra)

    (buildpath/"config.yaml").write Utils.safe_popen_read(bin/"gitea-runner", "generate-config")
    pkgetc.install "config.yaml"
    # Create working dir for services
  end

  def caveats
    "Config file: #{pkgetc}/config.yaml"
  end

  service do
    run [opt_bin/"gitea-runner", "daemon", "--config", etc/"gitea-runner/config.yaml"]
    keep_alive successful_exit: true
    environment_variables PATH: std_service_path_env

    working_dir var/"lib/gitea-runner"
    log_path var/"log/gitea-runner.log"
    error_log_path var/"log/gitea-runner.err"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitea-runner --version")
    args = %w[
      --no-interactive
      --instance https://gitea.com
      --token INVALID_TOKEN
    ]
    output = shell_output("#{bin}/gitea-runner register #{args.join(" ")} 2>&1", 1)
    assert_match "Error: failed to register runner", output
  end
end
