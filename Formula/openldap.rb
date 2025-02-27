class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.5.4.tgz"
  sha256 "61c03c078d70cd859e504fa9555d7d52426eed4b29e6a39e828afc213e4fb356"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "8810cadba32515088aad764a5b3d27e78e8f9b39c5bc1d272f4518757de75230"
    sha256 big_sur:       "3cd664ef4e02c7034c0fbded6a9ce81d7995e7785547b4e2b4258be2c6ac2727"
    sha256 catalina:      "2a09c420f6510ca308e88839f6479f4578f93915224852c9b0ee23f8ac9a0c80"
    sha256 mojave:        "2aeca689b082906b3f9c655581bbc0d9b0642a93fe05f6b20d534a068e29d8c2"
    sha256 x86_64_linux:  "a95618554383809f8689936de9a462bdedbdbb38f17142a9972b026dc5ef5805"
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-accesslog
      --enable-auditlog
      --enable-bdb=no
      --enable-constraint
      --enable-dds
      --enable-deref
      --enable-dyngroup
      --enable-dynlist
      --enable-hdb=no
      --enable-memberof
      --enable-ppolicy
      --enable-proxycache
      --enable-refint
      --enable-retcode
      --enable-seqmod
      --enable-translucent
      --enable-unique
      --enable-valsort
      --without-systemd
    ]

    # Disable manpage generation
    inreplace "Makefile.in" do |s|
      s.change_make_var! "SUBDIRS", "include libraries clients servers"
    end

    system "./configure", *args
    system "make", "install"
    (var/"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, Dir[etc/"openldap/*"]
    chmod 0755, Dir[etc/"openldap/schema/*"]
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
