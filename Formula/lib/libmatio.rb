class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.net/"
  url "https://github.com/tbeu/matio/releases/download/v1.6.0/matio-1.6.0.tar.gz"
  sha256 "1481dc74e01d249e90f064333f969369fe3dd11d6cc6963e8635c581aa5d7711"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_golden_gate: "a3f7d119f382252ad8dc80db7c1ba2db8f7986db5487c037ce03f19468eb9f06"
    sha256 cellar: :any,                 arm64_tahoe:       "9ca72d65bf5da29bddfbe606984e69151d6e26744783b2893a34e9318e7ae22c"
    sha256 cellar: :any,                 arm64_sequoia:     "7f5745b00f477b3aa6544162e3bb0ae280898c04041f3b1350bfc507638f040e"
    sha256 cellar: :any,                 arm64_sonoma:      "047c7d990b169c3ba1215246b4db54cd8ff33b7a194c67e8060aa7ce62c66486"
    sha256 cellar: :any,                 sonoma:            "83734b9696e4075b6bb93b5759a39f61195f01fa915879912d2622489813d2af"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "96ccac4352f0a05a8b17132ffd0ea5f0d6fa9fc26f0f7512c0e3b85616eaf8d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "75875bd017f8e01b60e5bf97fc8140440e0dcaa018c4e2d7809f20b31cfd3071"
  end

  depends_on "pkgconf" => :test
  depends_on "hdf5"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "homebrew-test_mat_file", :test do
    url "https://web.uvic.ca/~monahana/eos225/poc_data.mat.sfx"
    sha256 "a29df222605476dcfa660597a7805176d7cb6e6c60413a3e487b62b6dbf8e6fe"
  end

  def install
    args = %W[
      --enable-extended-sparse=yes
      --enable-mat73=yes
      --with-hdf5=#{formula_opt_prefix("hdf5")}
    ]
    args << "--with-zlib=#{formula_opt_prefix("zlib-ng-compat")}" unless OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    testpath.install resource("homebrew-test_mat_file")
    (testpath/"mat.c").write <<~C
      #include <stdlib.h>
      #include <matio.h>

      size_t dims[2] = {5, 5};
      double data[25] = {0.0, };
      mat_t *mat;
      matvar_t *matvar;

      int main(int argc, char **argv) {
        if (!(mat = Mat_Open(argv[1], MAT_ACC_RDONLY)))
          abort();
        Mat_Close(mat);

        mat = Mat_CreateVer("test_writenan.mat", NULL, MAT_FT_DEFAULT);
        if (mat) {
          matvar = Mat_VarCreate("foo", MAT_C_DOUBLE, MAT_T_DOUBLE, 2,
                                 dims, data, MAT_F_DONT_COPY_DATA);
          Mat_VarWrite(mat, matvar, MAT_COMPRESSION_NONE);
          Mat_VarFree(matvar);
          Mat_Close(mat);
        } else {
          abort();
        }
        mat = Mat_CreateVer("foo", NULL, MAT_FT_MAT73);
        return EXIT_SUCCESS;
      }
    C
    system ENV.cc, "mat.c", "-o", "mat", "-I#{include}", "-L#{lib}", "-lmatio"
    system "./mat", "poc_data.mat.sfx"

    refute_includes "-I/usr/include", shell_output("pkgconf --cflags matio")
  end
end
