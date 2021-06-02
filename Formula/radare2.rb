class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.2.1.tar.gz"
  sha256 "1f0a85fd53ebe003ceb94735ecb4c2f7966f6270526bf1461faaf301658c57e9"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git"

  bottle do
    sha256 arm64_big_sur: "755fab3de601eb450caadd19a633faf325d4b7b6614704ac6d84e8bb916915a5"
    sha256 big_sur:       "194f3f45fb07003d0bec13490d94d569c1fcaf446d638d5fc97899a566f024ef"
    sha256 catalina:      "f6078bb12999786fa57256724e08695a807e00cf4b28eca0e06a882ae8e2143c"
    sha256 mojave:        "f1b5d2befb4fe5b2052965a5a42e136aa4da1438feedfc5648a8be03b050e300"
    sha256 x86_64_linux:  "8d8f5b31c763b6a95799d35f1b212e964a3b84d009085a990a4d6d9749c0e678"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
