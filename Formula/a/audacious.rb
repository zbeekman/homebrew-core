class Audacious < Formula
  desc "Lightweight and versatile audio player"
  homepage "https://audacious-media-player.org/"
  license "BSD-2-Clause"

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-4.6.2.tar.bz2"
    sha256 "af4c68b7dd09304d382df18616aecd843c8efa4e4eef31bfc76abce465271c83"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-4.6.2.tar.bz2"
      sha256 "c295c65bdaae71775b4fa9eb206799c627b383c4f45444d637c714196daf8077"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url "https://audacious-media-player.org/download"
    regex(/href=.*?audacious[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "3422796a4b46b3b52f24d4ed35eda5bbbb312b7768402db56fe398dc7e2176cb"
    sha256 arm64_tahoe:       "48dbe878fd9df67c86b7e437c2e4770f033f834cada423a10ae66c3a4c6b1113"
    sha256 arm64_sequoia:     "2cfb53981e028830ddd8bef9502f4561f46f873ae4033799dc7a27aa9edc0cea"
    sha256 arm64_sonoma:      "314fe296aa6b20dd16824fa0394edbc5212a0096043ef696b492d195666325e4"
    sha256 sonoma:            "e3490319addfa23b35a3b745bfd62eb6db3a3a363202af70ceaf9774d64cbc48"
    sha256 arm64_linux:       "6a9f6156904b0ef56f775d6818f0ba9ff33ec855665e62ffbd7925534727ece3"
    sha256 x86_64_linux:      "3617052325f3933306defaf34cadcef3d0c8b40aca0fb89b47c1b2f5a338f2d3"
  end

  head do
    url "https://github.com/audacious-media-player/audacious.git", branch: "master"

    resource "plugins" do
      url "https://github.com/audacious-media-player/audacious-plugins.git", branch: "master"
    end
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "qttools" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "lame"
  depends_on "libbs2b"
  depends_on "libcue"
  depends_on "libmodplug"
  depends_on "libnotify"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "neon"
  depends_on "opusfile"
  depends_on "qtbase"
  depends_on "qtimageformats" => :no_linkage # for webp album covers
  depends_on "qtmultimedia"
  depends_on "qtsvg" => :no_linkage # for svg icons
  depends_on "sdl3"
  depends_on "wavpack"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
    depends_on "libx11"
    depends_on "libxml2"
    depends_on "pipewire"
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    odie "plugins resource needs to be updated" if build.stable? && version != resource("plugins").version

    args = %w[
      -Dgtk=false
    ]

    system "meson", "setup", "build", "-Ddbus=false", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    resource("plugins").stage do
      args += %w[
        -Dmpris2=false
      ]

      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      system "meson", "setup", "build", *args, *std_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end
  end

  def caveats
    <<~EOS
      audtool does not work due to a broken dbus implementation on macOS, so it is not built.
      GTK+ GUI is not built by default as the Qt GUI has better integration with macOS,
      and the GTK GUI would take precedence if present.
    EOS
  end

  test do
    system bin/"audacious", "--help"
  end
end
