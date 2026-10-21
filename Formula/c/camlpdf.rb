class Camlpdf < Formula
  desc "OCaml library for reading, writing and modifying PDF files"
  homepage "https://github.com/johnwhitington/camlpdf"
  url "https://github.com/johnwhitington/camlpdf/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "b90f79dacd9cfbae140581c8548b3d2e5cdda7176ce62d2724e616f94750f6cb"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8622f4faf3a68302b19a14c6956c853f5b28d4bd6adbcd2e115c3fe7f41d48f7"
    sha256 cellar: :any, arm64_tahoe:       "d230195e3669115b5c9f13685055d91d349e1f585de5920877314ed75ac82a62"
    sha256 cellar: :any, arm64_sequoia:     "2d4802aa515ad59381258620151faef8ccb4273b8a60036eb25f62d82ffe9896"
    sha256 cellar: :any, arm64_linux:       "601c933dc03bc2a863f4a2c4eb39ee5de5232c73218389300c179101b5df6dcc"
    sha256 cellar: :any, x86_64_linux:      "62a0307c0039cec147c066be4a3da3e2712b23e7e972731537571a461565541c"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "ocaml"

  def install
    # For OCamlmakefile
    ENV.deparallelize

    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = formula_opt_libexec("ocaml-findlib")/"findlib.conf"
    end

    ENV["OCAMLFIND_DESTDIR"] = lib/"ocaml"

    (lib/"ocaml").mkpath
    cp formula_opt_lib("ocaml")/"ocaml/Makefile.config", lib/"ocaml"

    # install in #{lib}/ocaml not #{HOMEBREW_PREFIX}/lib/ocaml
    inreplace lib/"ocaml/Makefile.config" do |s|
      s.change_make_var! "prefix", prefix
    end

    system "make"
    (lib/"ocaml/stublibs").mkpath # `make install` assumes this directory exists
    system "make", "install", "STDLIBDIR=#{lib}/ocaml"

    rm lib/"ocaml/Makefile.config" # avoid conflict with ocaml
  end

  test do
    (testpath/"test.ml").write "Pdfutil.flprint \"camlpdf\""
    system formula_opt_bin("ocaml")/"ocamlopt", "-I", lib/"ocaml/camlpdf", "-I",
           formula_opt_lib("ocaml")/"ocaml", "-o", "test", "camlpdf.cmxa",
           "test.ml"
    assert_match "camlpdf", shell_output("./test")
  end
end
