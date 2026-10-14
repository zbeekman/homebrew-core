class Vercel < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-64.0.1.tgz"
  sha256 "ff8fa8fbeae4a94c71662a5ac80f6876616da0c6db4770a10f925bebff63581c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "1c43b68a511c8c62395a47839521f8e0b34bbe6677087c8b762296736cf5bca7"
    sha256 cellar: :any,                 arm64_tahoe:       "1c43b68a511c8c62395a47839521f8e0b34bbe6677087c8b762296736cf5bca7"
    sha256 cellar: :any,                 arm64_sequoia:     "1c43b68a511c8c62395a47839521f8e0b34bbe6677087c8b762296736cf5bca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "25fec0185d279e503ffe820aba63ce8db742c4080acbc9144d19bd36f03363f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0132376caec3690e6ef25360a187abbb6e8819214a0ffdbe9d3a473f5f95e23c"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    proxy_arch = Hardware::CPU.intel? ? "amd64" : "arm64"
    ["@vercel/go", "@vercel/rust"].each do |package|
      (node_modules/package/"bin").glob("**/proxy-*").each do |f|
        next if OS.linux? && f.basename.to_s == "proxy-linux-#{proxy_arch}"

        rm f
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
