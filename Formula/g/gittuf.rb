class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://github.com/gittuf/gittuf/releases/download/v0.17.0/gittuf.src.tar.gz"
  sha256 "a3fa3cb08baa4799d7d2a70691cdc803ed7d26abc77223c132803ff622480996"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8701fa8fc6b256f652f6e6db9c1283386e6a39a6b874e43aec9051b5786a63a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8701fa8fc6b256f652f6e6db9c1283386e6a39a6b874e43aec9051b5786a63a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8701fa8fc6b256f652f6e6db9c1283386e6a39a6b874e43aec9051b5786a63a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c8701fa8fc6b256f652f6e6db9c1283386e6a39a6b874e43aec9051b5786a63a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c6d0677fa83c63a1a849bd90098a320b7ec1e55b6fc85f3ff2c329faaf16a91c"
    sha256 cellar: :any,                 x86_64_linux:      "5ff544a07b8d8f4c780d18b785f56e75fe8eada71cd5c022bc67995ba4b5e06a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gittuf", shell_parameter_format: :cobra)
  end

  test do
    system "git", "init"

    output = shell_output("#{bin}/gittuf policy init 2>&1", 1)
    assert_match(
      /Error: (required flag "signing-key" not set|signing key not specified in Git configuration)/,
      output,
    )

    output = shell_output("#{bin}/gittuf sync 2>&1", 1)
    assert_match "Error:", output
    assert_match(/(unable to identify git directory for repository|No such remote 'origin')/, output)

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end
