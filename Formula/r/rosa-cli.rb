class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.67.tar.gz"
  sha256 "923470271028de4397e416f0aee24dd05be61718869f6a2e0be484110d3b0171"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "65a856bcc88004e409953366651c72506d8196b8e2f882cbe08eeab967ff7492"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75690814724fb3a3aa433d7e457b883e16be3b5fbfe284444c2e6520ae43e3dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1f88a6e6eecd8931d85588d030d422bf76ec2e08d6bcd0d2d0e5cca89f5479f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "41a52d2c34c0ccccb48055dfbefe1e36aa8a5440c9fd024e236ea2500fa89def"
    sha256 cellar: :any,                 x86_64_linux:      "8ea4f1ac1fab134a5ae2081e2a57029d28477b64228e835fa7c3dbf1cdb7028f"
  end

  depends_on "go" => :build
  depends_on "awscli"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"

    generate_completions_from_executable(bin/"rosa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/rosa create cluster 2<&1", 1)
    assert_match "Failed to create OCM connection: Not logged in", output

    assert_match version.to_s, shell_output("#{bin}/rosa version")
  end
end
