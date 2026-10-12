class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagucloud/dagu/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "cd1d1cdc351efb88d5d3e91be019040dd550b139cd8b22c2ab6d051102c22ae7"
  license "GPL-3.0-only"
  head "https://github.com/dagucloud/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3154fbc5fcc527c97c53be9fa56047eac09e7fa2112417083023e0b1b0943216"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c674e4dd3d84d53697c5beac7791916d0003bd8f9f4b0d48427a0743a6328f2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "20912e44bb8c6b0f5cc2dd77080d6f721b4fb5a1e473e854eb45c74749051b0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dfe8a65ce08425d30f9c83c52864c30f499bc90ab259eb831d621410bc27551d"
    sha256 cellar: :any,                 x86_64_linux:      "49b19e4af140659fcd5773af1f24da248012cdf297c86fd2b56bddb866538ebc"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  allow_network_access! :test

  def fetch
    system "pnpm", "with", "current", "--dir", "ui", "fetch", "--ignore-scripts"
    system "go", "mod", "download"
  end

  def install
    system "pnpm", "--offline", "with", "current", "--dir", "ui", "install", "--frozen-lockfile", "--ignore-scripts"
    system "pnpm", "with", "current", "--dir", "ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd"
    generate_completions_from_executable(bin/"dagu", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"dagu", "start-all"]
    keep_alive true
    error_log_path var/"log/dagu.log"
    log_path var/"log/dagu.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dagu version 2>&1")

    (testpath/"hello.yaml").write <<~YAML
      steps:
        - name: hello
          command: echo "Hello from Dagu!"

        - name: world
          command: echo "Running step 2"
    YAML

    system bin/"dagu", "start", "hello.yaml"
    shell_output = shell_output("#{bin}/dagu status hello.yaml")
    assert_match "Result: Succeeded", shell_output
  end
end
