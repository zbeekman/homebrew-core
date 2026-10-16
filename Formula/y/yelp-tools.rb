class YelpTools < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://gitlab.gnome.org/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/42/yelp-tools-42.1.tar.xz"
  sha256 "3e496a4020d4145b99fd508a25fa09336a503a4e8900028421e72c6a4b11f905"
  license "GPL-2.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "cf1f178117fd252a7aa56d03e4579b315e300824ec2cfb7fcb4ddd1e106e06a7"
    sha256 cellar: :any,                 arm64_tahoe:       "0a3f9404c8d97b4e5bf674a6a412a4d0ebe70264cf7d3e1f2bc7457d4ec50105"
    sha256 cellar: :any,                 arm64_sequoia:     "a9cb317bc7a4ab248246e110c4fe84a545497a03ca03e22bbd9149a5d5fcc997"
    sha256 cellar: :any,                 arm64_sonoma:      "64dc7141411fd67c7fadf810871698084a38550d98f0434e95b4e5567f43ad8e"
    sha256 cellar: :any,                 sonoma:            "0e0d0165ca19b4bc03d8907462d3b7204c3763eaee291bb49236dd33bf98e20b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ade5f26615b99ea03312c681075265f29020713ad10f928205ac354d30bbd8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8b46a9066e4361ba000c17ddc5b05e5016432dd6576c7ad3cd4e369af635f5fa"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "python@3.15"
  depends_on "yelp-xsl" => :no_linkage

  uses_from_macos "libxslt"

  pypi_packages package_name:   "",
                extra_packages: "lxml"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "mallard-rng" do
    url "https://github.com/projectmallard/projectmallard.org/raw/refs/tags/mallard-rng-1.1.0/download/mallard-rng-1.1.0.tar.bz2"
    mirror "https://deb.debian.org/debian/pool/main/m/mallard-rng/mallard-rng_1.1.0.orig.tar.bz2"
    sha256 "66bc8c38758801d5a1330588589b6e81f4d7272a6fbdad0cd4cfcd266848e160"

    livecheck do
      url :url
      regex(/^mallard-rng[._-]v?(\d+(?:\.\d+)+)$/i)
    end
  end

  def install
    resource("mallard-rng").stage do
      system "./configure", "--disable-silent-rules", *std_configure_args(prefix: libexec)
      system "make", "install"
    end

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources.reject { |r| r.name == "mallard-rng" }
    ENV.prepend_path "PATH", venv.root/"bin"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children

    xml_catalog_files = libexec/"etc/xml/mallard/catalog"
    bin.env_script_all_files(libexec/"bin", XML_CATALOG_FILES: "${XML_CATALOG_FILES:-#{xml_catalog_files}}")
  end

  test do
    system bin/"yelp-new", "task", "ducksinarow"
    system bin/"yelp-build", "html", "ducksinarow.page"
    system bin/"yelp-check", "validate", "ducksinarow.page"
  end
end
