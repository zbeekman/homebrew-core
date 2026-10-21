class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.2.3.tar.gz"
  sha256 "c0b9dd0f636a2405c4cb2bb6fea6a53a998d4905b7fb5afe5fc15f080a8e98e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "30349c15fde5c00e95d0ec29cad7bb5ed2462aa98cbf1ec351a1c09bd31d26eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30349c15fde5c00e95d0ec29cad7bb5ed2462aa98cbf1ec351a1c09bd31d26eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "30349c15fde5c00e95d0ec29cad7bb5ed2462aa98cbf1ec351a1c09bd31d26eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f2abdaee0cd9d6217ac036ed74417968c63f28c793f8e1146f2336edca242dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f2abdaee0cd9d6217ac036ed74417968c63f28c793f8e1146f2336edca242dbd"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("25")
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
