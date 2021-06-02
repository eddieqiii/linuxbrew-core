class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.116.0",
      revision: "c945afc8d8ab260216776e07f3b15f17d406c3a6"
  license "MIT"
  head "https://github.com/influxdata/flux.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "73a699ca324cabf58fc642eb4c916d8e5b8a71b19e35dd7985cae7a5d98eb813"
    sha256 cellar: :any,                 big_sur:       "cf580513997e856140e962ffd8adc0869034c6e8bdb06853e141db2a610cdb76"
    sha256 cellar: :any,                 catalina:      "5b7886df7cc8f23fcb54c9d761454c5c0ba09858b0f15a028b6b956d6a27d23a"
    sha256 cellar: :any,                 mojave:        "e9480a01a98aafeb36653028249b3184fb2d4baa64c989ea175693cef3ffc3ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44c8a3545830f8beca69516c89844c0b8dba74ddee0ea2985e5af1a84493fc18"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
    depends_on "pkg-config" => :build
    depends_on "ragel" => :build
  end

  def install
    system "make", "build"
    system "go", "build", "./cmd/flux"
    bin.install %w[flux]
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    assert_equal "8\n", shell_output("flux execute \"5.0 + 3.0\"")
  end
end
