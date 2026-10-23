class VitePlus < Formula
  desc "Unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "c1d15c0b059753878b47816329f275274dbf42f958a071e4ada79fa0f54c4152"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6407aa970a40019a874a624798145563cf00756b60101a3f0dfc1bca12817d12"
    sha256 cellar: :any, arm64_tahoe:       "0028a60c7d8202ae1d19280dc3542d3c8b79242ea3a057d1b653cbcadadcc813"
    sha256 cellar: :any, arm64_sequoia:     "e6db227319977fb5c0dda28936f70080f19d4f2d61a3e38cb84048ff66c9e514"
    sha256               arm64_linux:       "7e17e8e4af1540668c288602493e77efbf34160c47b8f1c7fa090afad59f20a8"
    sha256               x86_64_linux:      "7cd68b1e92d96bc1500d431c766d1944d609f2ff48f40eb5606405aaa7360f57"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "node"
  depends_on "sqlite"

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "89d821ca07cf9ccd84dd92bd3f48af0f579ab21a"
    version "89d821ca07cf9ccd84dd92bd3f48af0f579ab21a"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "981f07fa4580fb88b333c4450431e4715d2a0b82"
    version "981f07fa4580fb88b333c4450431e4715d2a0b82"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("vite", "hash")
      end
    end
  end

  resource "oxc-node" do
    url "https://github.com/oxc-project/oxc-node.git",
        revision: "4759cedbda87f67ca646d3277166884cfcd62f81"
    version "4759cedbda87f67ca646d3277166884cfcd62f81"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("oxc-node", "hash")
      end
    end
  end

  def install
    resource("rolldown").stage buildpath/"rolldown"
    resource("vite").stage buildpath/"vite"
    resource("oxc-node").stage buildpath/"oxc-node"

    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    ENV["RUSTC_BOOTSTRAP"] = "1" # workaround to build with stable rust

    # Build with Homebrew pnpm. The staged resources pin their own versions too
    %w[package.json rolldown/package.json vite/package.json].each do |file|
      package_json = buildpath/file
      package_json.atomic_write(JSON.pretty_generate(JSON.parse(package_json.read).except("packageManager")))
    end

    # Point the vendored oxc-node at the workspace's oxc version, as upstream CI does
    system "node", "packages/tools/src/patch-oxc-node.ts"

    # Align the staged Vite's Vitest versions with the lockfile, as upstream CI does
    system "node", "packages/tools/src/vendored-vitest.ts"

    # Vite patches only build-time dependencies, which the production deploy below omits
    (buildpath/"pnpm-workspace.yaml").append_lines "allowUnusedPatches: true"

    system "just", "build"
    system "cargo", "install", *std_cargo_args(path: "crates/vp_global_cli")

    system "pnpm", "--filter=vite-plus", "deploy", "--prod", "--legacy", "--no-optional",
           prefix/"node_modules/vite-plus"
    node_modules = prefix/"node_modules/vite-plus/node_modules"
    # Remove incompatible pre-built `bare-*` binaries. Recurse as `deploy --legacy` writes
    # both the legacy `<name>@<version>` and the current `@/<name>/<version>/<hash>` layouts
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob(".pnpm/**/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    rm_r node_modules.glob(".pnpm/**/node_modules/fsevents")

    # Symlink vp to vpr and vpx. These are detected at runtime by argv[0]
    bin.install_symlink bin/"vp" => "vpr"
    bin.install_symlink bin/"vp" => "vpx"

    # Generate shell completions, vp uses clap but with a custom env var so we can't use our helper
    (bash_completion/"vp").write Utils.safe_popen_read({ "VP_COMPLETE" => "bash" }, bin/"vp")
    (fish_completion/"vp.fish").write Utils.safe_popen_read({ "VP_COMPLETE" => "fish" }, bin/"vp")
    (zsh_completion/"_vp").write Utils.safe_popen_read({ "VP_COMPLETE" => "zsh" }, bin/"vp")
  end

  test do
    # Use Homebrew node and skip the first-run setup prompt, which stops `vp` on the test PTY
    ENV["VP_NODE_MANAGER"] = "no"

    assert_match version.to_s, shell_output("#{bin}/vp --version")

    # `vp` calls `tcsetattr` on a tty stdin, which stops it with SIGTTOU on the test PTY
    system "#{bin}/vp create vite:application --no-interactive --directory test-app < /dev/null"
    assert_path_exists testpath/"test-app/package.json"

    cd testpath/"test-app" do
      output = shell_output("#{bin}/vp fmt < /dev/null")
      assert_match "Finished", output
    end
  end
end
