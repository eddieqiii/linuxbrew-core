class Usbredir < Formula
  desc "USB traffic redirection library"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/usbredir/usbredir-0.9.0.tar.xz"
  sha256 "a3e167bf42bc7fe02c3c9db27d7767f1b8ce41b99ad14a4b0d0a60abe8bf56a6"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  livecheck do
    url "https://www.spice-space.org/download/usbredir/"
    regex(/href=.*?usbredir[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e1b386db632be8bb241c1924f0d1ca892c069078f1d1928c7ea1f786e4a834e1"
    sha256 cellar: :any,                 big_sur:       "5f2999d6b52b9ccc9aee6efc1417083d6fd3bb10b873cb56c2debcb02e4e9c82"
    sha256 cellar: :any,                 catalina:      "a19338a4180caf513da9caeda32403311002715609ef7200d31c0d96f49e4fa1"
    sha256 cellar: :any,                 mojave:        "7660673efa01fe1af1337ba2dc290a39c8a45a54287e1cfe5daa5efac583cc14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10400d9b4c1e92763e3856c08c33f9723081aefd87f454faf823f809cc7f072c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    # Use meson from the release after 0.9.0
    system "autoreconf", "-fiv"
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <usbredirparser.h>
      int main() {
        return usbredirparser_create() ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-L#{lib}",
                   "-lusbredirparser",
                   "-o", "test"
    system "./test"
  end
end
