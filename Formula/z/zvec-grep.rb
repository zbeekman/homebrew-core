class ZvecGrep < Formula
  desc "Agent-friendly hybrid workspace search across code and non-code content"
  homepage "https://github.com/zvec-ai/zvec-grep"
  url "https://registry.npmjs.org/@zvec/zvec-grep/-/zvec-grep-0.2.2.tgz"
  sha256 "a958bb24f161c6d092fe555ddeeb44989f933354d9e21392d89af4bc75bd4393"
  license "Apache-2.0"

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "node"
  depends_on "ripgrep"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-13.1.0.tgz"
    sha256 "15663ca4944844139023390f057e86f1897d855959ea7e96f151d4873be8c71f"

    livecheck do
      url :url
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@zvec/zvec-grep/node_modules"

    # Use `rg` from PATH: zg falls back to it when `@vscode/ripgrep` is absent
    rm_r node_modules.glob("@vscode/ripgrep*")

    # Rebuild `sharp` against our `vips` instead of its pre-built libvips
    rm_r node_modules.glob("@img/sharp-*")
    resource("node-gyp").stage do
      system "npm", "install", *std_npm_args(prefix: buildpath/"node-gyp")
      ENV.append_path "NODE_PATH", buildpath/"node-gyp/lib/node_modules"
    end
    cd node_modules/"sharp" do
      ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
      system "npm", "run", "build"
      rm_r "src/build/Release/obj.target"
    end

    # Remove pre-built binaries for other platforms
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    node_modules.glob("onnxruntime-node/bin/napi-v3/*").each { |dir| rm_r dir if dir.basename.to_s != os }
    node_modules.glob("onnxruntime-node/bin/napi-v3/*/*").each { |dir| rm_r dir if dir.basename.to_s != arch }
    llama_target = OS.mac? ? "mac-#{arch}" : "linux-#{arch}"
    llama_target += "-metal" if OS.mac? && Hardware::CPU.arm?
    node_modules.glob("@node-llama-cpp/*").each { |dir| rm_r dir if dir.basename.to_s != llama_target }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zg --version")

    (testpath/"f.txt").write("hello unified search\n")
    assert_match "hello", shell_output("#{bin}/zg query --rg hello #{testpath} 2>&1")
  end
end
