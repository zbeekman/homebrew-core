class Mcat < Formula
  desc "Terminal image, video, directory, and Markdown viewer"
  homepage "https://github.com/Skardyy/mcat"
  url "https://github.com/Skardyy/mcat/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "f5fc7043ed5b5c467383ba1e2e62f493e629ad729a910d46202cfaa16d58b80a"
  license "MIT"
  head "https://github.com/Skardyy/mcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "65b5fdddf624425860a972599c43b0ede36764779e1f7b6470b27ded8e768505"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "37eee59c4d98186de389836b9a70dea4e5a56654a5bf230924ca1f53f5144d9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2bb0b6017ab2e805c7d19ae4abe23b776161149063225d86a6d48a0555f9bc33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "eba8da8ec142bd8d603ed1998377ac926bf7a29c86e134d124745341af0be33b"
    sha256 cellar: :any,                 arm64_linux:       "0edf6a0f117170b07bc1f8e54dedc3eb8e714fa9f0871c8463be15a4aebafb6f"
    sha256 cellar: :any,                 x86_64_linux:      "ada543b6769a56b0632afc92284a26588fbb642e135200ac30b30678e69ce344"
  end

  depends_on "rust" => :build

  conflicts_with "mtools", because: "both install `mcat` binaries"

  # Avoid hanging when probing a terminal that does not answer: macOS poll(2) does
  # not support ttys, and a background process group is stopped by SIGTTOU/SIGTTIN
  # Upstream PR ref: https://github.com/Skardyy/mcat/pull/109
  patch do
    url "https://github.com/Skardyy/mcat/commit/1dcf9b3cca130086d17641d73811535c3826b29b.patch?full_index=1"
    sha256 "559307c6ddbd0217495b05024a374791aa591dcb174807efea52074cea2090ad"
    type :unofficial
    resolves "https://github.com/Skardyy/mcat/pull/109"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/core")

    generate_completions_from_executable(bin/"mcat", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcat --version")

    (testpath/"test.md").write <<~MD
      # Hello World

      This is a **test** of _mcat_!
    MD

    output = shell_output("#{bin}/mcat #{testpath}/test.md")
    assert_match "# Hello World\n\nThis is a **test** of _mcat_!", output
  end
end
