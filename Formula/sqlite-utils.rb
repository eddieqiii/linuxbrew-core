class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/3a/40/9461a52974c5f5eb1ec5eb804ef3a84c5da878f443eea368c88b7c5c428f/sqlite-utils-3.7.tar.gz"
  sha256 "86f7ef80ca52fbf8c5692bfbf41572cb07421e7030f96278b977a439d4d95b06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7039347e1f69e054b19871ed46f361b5ee960ec854527d3133e2c2b50850dddb"
    sha256 cellar: :any_skip_relocation, big_sur:       "a4e75bc4e45a483b71cbed7a3f2f088a10aef5508873e6d7391aedca16bc25fc"
    sha256 cellar: :any_skip_relocation, catalina:      "a4e75bc4e45a483b71cbed7a3f2f088a10aef5508873e6d7391aedca16bc25fc"
    sha256 cellar: :any_skip_relocation, mojave:        "a4e75bc4e45a483b71cbed7a3f2f088a10aef5508873e6d7391aedca16bc25fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a22d8f20baec5c138250149019a7f4ecc6f9d818436e9991685995ec09a7d88"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/62/30/63e64b7b8fa69aabf97b14cbc204cb9525eb2132545f82231c04a6d40d5c/sqlite-fts4-1.0.1.tar.gz"
    sha256 "b2d4f536a28181dc4ced293b602282dd982cc04f506cf3fc491d18b824c2f613"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
