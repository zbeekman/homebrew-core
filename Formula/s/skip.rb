class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.9.16.tar.gz"
  sha256 "c8ceedb6b93ffee714c2162b84cee81f0569faf0a41af62d3a42e9e3d7391cc1"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "59c6b868b5caed8f265d20256341651cf8222e3fe3414350cd5a19cb9885f45d"
    sha256 arm64_tahoe:       "f2d909be2d4891208e3ed6a683669648bd30f736aee95dcf348ae025d92b9f9f"
    sha256 arm64_sequoia:     "77330d9c54784195ed468389cc0cebc30539f6eecb4bc341d1debc405329e61f"
    sha256 arm64_linux:       "7cc61e15f46fa7df06f68f8b4d6e60aca1997787c0c8c6810827cf2be84300ab"
    sha256 x86_64_linux:      "41982482068957281c8b980091af387b5f79728f04b8f0d3618089f0cb80eb0f"
  end

  depends_on "gradle"
  depends_on "openjdk"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on xcode: :build
  end

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  resource "skipsubmodule" do
    url "https://github.com/skiptools/skip/archive/refs/tags/1.9.16.tar.gz"
    sha256 "e855d7dd331d8ab08099b822d59f9cc6e574015ff744bb1c2112f4de1afaeb07"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    # FIXME: need to update brew as Swift 6.4.0+ doesn't use ld shim anymore
    if OS.linux?
      args = ENV["HOMEBREW_LIBRARY_PATHS"].to_s.split(":").flat_map { ["-Xlinker", "-L#{it}"] } +
             ENV["HOMEBREW_RPATH_PATHS"].to_s.split(":").flat_map { ["-Xlinker", "-rpath", "-Xlinker", it] }
    end

    system "swift", "build", "--product", "SkipRunner", *args, *std_swift_args
    bin.install ".build/release/SkipRunner" => "skip"
    generate_completions_from_executable(bin/"skip", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skip version")
    system bin/"skip", "welcome"
    system bin/"skip", "init", "--no-build", "--transpiled-app", "--appid", "some.app.id", "some-app", "SomeApp"
    assert_path_exists testpath/"some-app/Package.swift"
  end
end
