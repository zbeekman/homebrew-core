class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.25.11.tar.gz"
  sha256 "86e39d346bc6b923cb9cf3ab5184284955a48e243a76e806ec7ce0c66ec92ed7"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "000c4bd6a51af380ba47b246c0d908962a858e7ae49130ff417faa9a8c9fefd2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c7b8977f33a980d5328504d436a154c7612bd4e66325210f60459c0ccc5e57a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a91004bd9d5949e953a18acfe091fbeb9e1617bf04ad7d001c013409bc3f073b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f58990eefc2779fd69c48a33bb3ccb5e7ff654ed7d97456e26ccef5cd469c3d"
    sha256 cellar: :any,                 x86_64_linux:      "741b0411cea451dbfe1ac08f940b7c22ffb36c088af9722e850af70daad54f96"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
