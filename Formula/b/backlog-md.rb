class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.55.2.tar.gz"
  sha256 "defd47f30b787a69bcf888499ea95ddd0ce6fc352c775a0b12010485b874b6c8"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "aa0fca1715ccafad12ffe38231027a8003e7c871af8ed801faf4bf848cf9d723"
    sha256 arm64_tahoe:       "a3398befc8f4962748ae534caa9815262a1f1c65a2335e2e6564eca2ba66aabd"
    sha256 arm64_sequoia:     "326550f93778de21595e82bd6dd9551f9682e4c9efe5944d4664181716209830"
    sha256 arm64_linux:       "1c94a2ead86f9719041dced77c7bcbb6e660b55fcc5a112f8c10f6d0906e3784"
    sha256 x86_64_linux:      "015503c7f1c1a69365e3a8ed36991bb0b99dffc70cbaaebb153448625cffa2d6"
  end

  depends_on "bun" => :build

  on_linux do
    # `bun build --compile` embeds the runtime, so the output inherits bun's ICU linkage.
    depends_on "icu4c@78"
  end

  deny_network_access!

  def fetch
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula
      icu = deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula

      odie "Update icu4c dependency!" if bun_icu.name != icu.name
    end

    # Upstream injects the version at release time; the tagged `package.json` lags.
    ENV["BACKLOG_BUILD_VERSION"] = version.to_s

    # Not `bun run build`: that resolves `bun` from `node_modules/.bin`, and
    # `bun build --compile` embeds whichever runtime ran the build.
    system "bun", "scripts/build.ts"

    bin.install "dist/backlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
