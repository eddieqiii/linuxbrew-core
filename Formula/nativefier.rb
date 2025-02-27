require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-43.1.3.tgz"
  sha256 "63757f0889c96a399db7bd3db4d9224d400fa78a0db9674be865d1c4188bff31"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e3b6786b041f9049d45f26b624ae69a2ed8a53cf3de72fc3bd10a50018499cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "c63b0779b6cd57cdd58b1bc3e936562c5ad9600eea6585b0ed4b32d7bfdbb0e1"
    sha256 cellar: :any_skip_relocation, catalina:      "c63b0779b6cd57cdd58b1bc3e936562c5ad9600eea6585b0ed4b32d7bfdbb0e1"
    sha256 cellar: :any_skip_relocation, mojave:        "c63b0779b6cd57cdd58b1bc3e936562c5ad9600eea6585b0ed4b32d7bfdbb0e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8dd662ad4649687bd35ef0d1545968f39392cfcbf89f4ce43ad4c80113c58ef"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
