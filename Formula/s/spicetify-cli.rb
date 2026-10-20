class SpicetifyCli < Formula
  desc "Command-line tool to customize Spotify client"
  homepage "https://spicetify.app/"
  url "https://github.com/spicetify/cli/archive/refs/tags/v2.46.2/v2.46.2.tar.gz"
  sha256 "f4251e342851d2a9edf01c3cee6a66501ee9a29c58b4adf79a0ca548b1044da5"
  license "LGPL-2.1-only"
  head "https://github.com/spicetify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a587400890c0084cdabe893aeafb5da36115b4b57de0a11aa2116ef50da019ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a587400890c0084cdabe893aeafb5da36115b4b57de0a11aa2116ef50da019ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a587400890c0084cdabe893aeafb5da36115b4b57de0a11aa2116ef50da019ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "07b1c46ea9b0da8f7ca0689ca9f63e5064d1145fa53da044ef1dcdffd6b242fc"
    sha256 cellar: :any,                 x86_64_linux:      "7e0f2bce38993937b7555cacc9e127695e9ec0b1efe80a923e9a6def0c9b87e6"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    system "pnpm", "with", "current", "install", "--frozen-lockfile"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: libexec/"spicetify")

    system "pnpm", "--offline", "with", "current", "run", "build:wrapper"

    libexec.install [
      "css-map.json",
      "CustomApps",
      "Extensions",
      "globals.d.ts",
      "jsHelper",
      "Themes",
    ]
    bin.install_symlink libexec/"spicetify"
  end

  test do
    spotify_folder = testpath/"com.spotify.Client"
    pref_file = spotify_folder/"com.spotify.client.plist"
    mkdir_p spotify_folder
    touch pref_file

    path = testpath/".config/spicetify/config-xpui.ini"
    path.write <<~INI
      [Setting]
      spotify_path            = #{spotify_folder}
      current_theme           = SpicetifyDefault
      prefs_path              = #{pref_file}
    INI

    quiet_system bin/"spicetify", "config"
    assert_match version.to_s, shell_output("#{bin}/spicetify -v")

    output = shell_output("#{bin}/spicetify config current_theme")
    assert_match "SpicetifyDefault", output
  end
end
