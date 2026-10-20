class Vifm < Formula
  desc "Ncurses-based file manager with vi-like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.14.5/vifm-0.14.5.tar.bz2"
  sha256 "5de33fd6637ce91cdce162358ec393f6fe5e9734deb1833ea16776d619960422"
  license "GPL-2.0-or-later"
  head "https://github.com/vifm/vifm.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "b7594b4369947c525ecc56a2328c7cbd3324b9eed694275ac4576e9b61f9b072"
    sha256 arm64_tahoe:       "f97fa172bca7120403ab18f6feb214e0b050c5fa1206bc3909672056901fd0e8"
    sha256 arm64_sequoia:     "51425c4014118f8b72ca6456831a3a5f06e8a7438d05db53ba8a1934e33cff0f"
    sha256 arm64_sonoma:      "ac486acf909d47efa6709c80a3e0c684fdb7f15d5bb923e4a07b00f5cdbd5a8c"
    sha256 sonoma:            "173003f1bfcf09f43608cb6f4a77f37b9a546f00306680699fa6f8f81ff3c66e"
    sha256 arm64_linux:       "ff0c5ca190d509329af0cc6e618a6cc51e1922d9b25a3c2147f469bc339d233f"
    sha256 x86_64_linux:      "a61d62b7dae9f72484ab57d65de32619c9aabaec2ab64c4438ad0715f65831cd"
  end

  depends_on "ncurses"

  uses_from_macos "mandoc" => :build

  deny_network_access!

  def install
    args = %W[
      --with-curses=#{formula_opt_prefix("ncurses")}
      --without-gtk
      --without-libmagic
      --without-X11
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vifm --version")
  end
end
