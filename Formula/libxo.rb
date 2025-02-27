class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/1.5.1/libxo-1.5.1.tar.gz"
  sha256 "c9153bd01232dfe40828a55320a4d337e3f334286788656d9a06352b88ea13d2"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_big_sur: "12bbc75f4c8246d85e00617b06bc3ad255e554841f84e1d0ba2cbf2fc0b14ed4"
    sha256 big_sur:       "a403d9dfd41e92094beddf4ff7d4fd490e2ce7c4dbaeb2ec64095182d171a635"
    sha256 catalina:      "71eaebeed3f6b9b1d4bb08019929fb0a3fbd68a69923ded21cefa6de1feae8fc"
    sha256 mojave:        "eb8f873d50703f142665c047e295fb09ffca521106025ba7b3c2404f85521ebf"
    sha256 x86_64_linux:  "b95ad1c603da17e40184647d3667595c34784dd3ecc5b7ad135b537df619f213"
  end

  depends_on "libtool" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libxo/xo.h>
      int main() {
        xo_set_flags(NULL, XOF_KEYS);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxo", "-o", "test"
    system "./test"
  end
end
