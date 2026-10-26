class Av1an < Formula
  desc "Cross-platform command-line encoding framework"
  homepage "https://github.com/rust-av/Av1an"
  url "https://github.com/rust-av/Av1an/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "f58096a084456acf66f2be273b6c70e05cb53831b2a8a5006569f08a5a7b575a"
  license "GPL-3.0-only"
  head "https://github.com/rust-av/Av1an.git", branch: "master"

  # Differentiate v-prefixed tags from old version schemes
  livecheck do
    url :stable
    regex(/^v(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f79bdb7a8964dea022165a087cef1a281c156696d9342387f83d19d8c39bf46d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6408b362fc09ef34a7d5518b4e963f975fbfcab9686605be0aff8b971e9f8ded"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "940cbc4f300478586beeed81b3cbfd1cf8e13e799ab2ce66d1397c8d57ddd72a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1af81225e8802d91363c75c58cfd492308710819c4e9b778db02b2fb612ff45c"
    sha256 cellar: :any_skip_relocation, sonoma:            "1cbb38b5c91e2c114fbc06f49ef3c7693e49447efbdff876a151624e5db8275a"
    sha256 cellar: :any,                 arm64_linux:       "c200efae60ac1c56f75b277546d1ebe8cfbb0d54ca683830480d351c0b288223"
    sha256 cellar: :any,                 x86_64_linux:      "cc0d5d979af9062de3ae2d2031749b38e49e3393158385f429732b8a1151fb9b"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "mkvtoolnix"
  depends_on "vapoursynth"

  on_intel do
    depends_on "nasm" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["VERGEN_GIT_COMMIT_DATE"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args(path: "av1an")

    generate_completions_from_executable(bin/"av1an", shell_parameter_format: "--completions=")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/av1an --version")

    cp test_fixtures("test.mp4"), testpath
    system bin/"av1an", "-i", testpath/"test.mp4", "-o", testpath/"test.av1.mkv"
    assert_path_exists testpath/"test.av1.mkv"
  end
end
