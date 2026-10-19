class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.166.0.tgz"
  sha256 "909c6fdc2cfcd57ae5fad522bf87778b40ed7a060a49fbd8eda2daa8ba4c03b0"
  license "AGPL-3.0-only"

  # livecheck needs to surface multiple versions for version throttling but
  # there are thousands of renovate releases on npm. The package page showing
  # versions is several MB in size (and the registry response is 10x that),
  # so curl can time out before the response finishes. This checks releases on
  # GitHub as a workaround, as it provides information on multiple versions
  # but has a much smaller size.
  livecheck do
    url :homepage
    strategy :github_releases
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f703e90ac4a54531932cdb97a989559935319a0cf982484101735f791ba7c7da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f703e90ac4a54531932cdb97a989559935319a0cf982484101735f791ba7c7da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f703e90ac4a54531932cdb97a989559935319a0cf982484101735f791ba7c7da"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8c99d139dbd61991ed00446f4ff4243d9a2e843adaffd924bcc9d8e39b3366ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8c99d139dbd61991ed00446f4ff4243d9a2e843adaffd924bcc9d8e39b3366ef"
  end

  depends_on "node@24"

  uses_from_macos "git", since: :monterey # needs git >= 2.33.0 (Apple Git-136)

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Renovate filters child env vars, so Homebrew's git shim cannot run.
    ENV.remove "PATH", HOMEBREW_SHIMS_PATH/"shared"
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
