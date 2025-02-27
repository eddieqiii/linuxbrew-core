class Iozone < Formula
  desc "File system benchmark tool"
  homepage "https://www.iozone.org/"
  url "https://www.iozone.org/src/current/iozone3_491.tgz"
  sha256 "efeea0e84ccd9b92920c60e2668caf6ef595c5d95e6cea89760a62eb64365df8"
  license :cannot_represent
  revision 1

  livecheck do
    url "https://www.iozone.org/src/current/"
    regex(/href=.*?iozone[._-]?v?(\d+(?:[._]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4931a6315b1fd26134106f356381f7488824f0e26b39ef1e8d0e967552e5bce"
    sha256 cellar: :any_skip_relocation, big_sur:       "5eac860da12c9354228065de651c6ad694735d743cc0e103adddeb0410e03fff"
    sha256 cellar: :any_skip_relocation, catalina:      "16f2d9c8927f2b3c77a386e7fd0e671caae18e0fe537617f89bc62fab59010e7"
    sha256 cellar: :any_skip_relocation, mojave:        "db9937b87103179af1950657d9f330063194987da6873e6177e759f878fd2949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1af2bb00831c9823e1b03551e3a19d0b498376f6d39074a30d6ee4643b570573"
  end

  def install
    cd "src/current" do
      on_macos do
        system "make", "macosx", "CC=#{ENV.cc}"
      end
      on_linux do
        system "make", "linux", "CC=#{ENV.cc}"
      end
      bin.install "iozone"
      pkgshare.install %w[Generate_Graphs client_list gengnuplot.sh gnu3d.dem
                          gnuplot.dem gnuplotps.dem iozone_visualizer.pl
                          report.pl]
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
  end
end
