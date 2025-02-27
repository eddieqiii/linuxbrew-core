class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.0.4.tar.gz"
  sha256 "4dd11c5842cb0edb6ced5d2046f1205de6503a3d9c4b55e8e29b6631a2fc311c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cc23111e7c822b0cd301fd16aaeb97af36dfac458293f23139cc39fa07caf230"
    sha256 cellar: :any_skip_relocation, big_sur:       "03b65170c424abf8a0654db62bde509706326b14a8011eb67031c080a4363c55"
    sha256 cellar: :any_skip_relocation, catalina:      "31634423ca9d62bfb4003eba227fe80452601d4e7f4f00f1fbbf4275ec5057b7"
    sha256 cellar: :any_skip_relocation, mojave:        "b9b91f3e5b0acce11046a57ed75476b9c7c030669e2139b7f14e15467f46d4e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18f709ff120f002ae294cdb4ddc2eaaf907f65658d51baecd988f2111093052d"
  end

  depends_on "pcre2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"echo.l").write <<~'EOS'
      %{
      #include <stdio.h>
      %}
      %option noyywrap main
      %%
      .+  ECHO;
      %%
    EOS
    system "#{bin}/reflex", "--flex", "echo.l"
    assert_predicate testpath/"lex.yy.cpp", :exist?
  end
end
