class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v2.4.1.tar.gz"
  sha256 "02af5be7fd2ef29c791bf1d73938d71f70651e267ca4ed7e03a3bbdc1cdad0e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8457ea0eef2847f68d2efe9e24c2dcc080d7b408f9eccb7e334565e0f65c92f6"
    sha256 cellar: :any,                 big_sur:       "3331c7a9ea9fb1f29026b08ca9563668dd713ee65d442ddcb38b97cabbcd2dd4"
    sha256 cellar: :any,                 catalina:      "8f8c924ef1b9024c9f87986919bfff3910d4cc8b5571e8e714efc05790030edd"
    sha256 cellar: :any,                 mojave:        "a4a45632c4b38923dba15216c645e0b9fe8efa17101f7dec02640e916ac73ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed8bfdc8d0cdab1d224208e65be8f3af76e869563e94ffb40c5db11328123119"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "protobuf-c"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                         "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
