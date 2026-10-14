class Planetiler < Formula
  desc "Flexible tool to build planet-scale vector tilesets from OpenStreetMap data fast"
  homepage "https://github.com/onthegomap/planetiler"
  url "https://github.com/onthegomap/planetiler/releases/download/v0.10.2/planetiler.jar"
  sha256 "f310bd0413e2e4512b27f4046d418664e8e1d3bf31603c2a70e23de06c167e4d"
  license "Apache-2.0"

  depends_on "openjdk"

  allow_network_access! :test

  def install
    libexec.install "planetiler.jar"
    bin.write_jar_script libexec/"planetiler.jar", "planetiler", "-XX:MaxRAMPercentage=50"
  end

  test do
    system bin/"planetiler", "--area=monaco", "--only-layers=poi", "--download", "--output=#{testpath}/monaco.pmtiles"
    assert_path_exists testpath/"monaco.pmtiles"
  end
end
