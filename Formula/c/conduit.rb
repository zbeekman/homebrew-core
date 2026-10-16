class Conduit < Formula
  desc "Streams data between data stores. Kafka Connect replacement. No JVM required"
  homepage "https://conduitio.github.io/"
  url "https://github.com/ConduitIO/conduit/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "d60f7fb4a250634d7efa298ccd381db1644a0f8668ab98a979dcff3f2f503654"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/conduit.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f118dc89b681259228b44b7bd419f0ec921e4875960a4cf4117a352f937cf8b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0fae586494268979e222fc9014d295840ad4a6e263a8456ecebc7411573942f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e541650edea0b09d4853bac45c92fe8c371350f8b340d52ea3afb1669499595c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "da8af7a0d8ccd9de207290fd62dac825483afb68d56f55635d607deb51929f34"
    sha256 cellar: :any,                 x86_64_linux:      "1418785fc5f9d9f6c5d56a19285492a70f57b99bf3b1fb80e979bdae39f2f052"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "make", "VERSION=#{version}"
    bin.install "conduit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/conduit --version")

    File.open("output.txt", "w") do |file|
      # redirect stdout to the file
      $stdout.reopen(file)
      pid = spawn bin/"conduit", "run", "--api.enabled", "true",
                                 "--api.grpc.address", ":0",
                                 "--api.http.address", ":0"
      sleep(5)
      # Kill process
      Process.kill("SIGKILL", pid)
    end
    assert_match "grpc API started", (testpath/"output.txt").read
    assert_match "http API started", (testpath/"output.txt").read
  end
end
