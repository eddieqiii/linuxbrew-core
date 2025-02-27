require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.27.0.tgz"
  sha256 "61cd0bdac9edf6dfbde8ce7a8c7d861620bf54f1d750e8e3116a1b609ce8719d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9296c54d152180b7c8b502cef5f299040ec61bfbfbca31ee50279eccd4fe70cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "f751b77ef2853782af49f076027d0b70870bd60a9aa678ba0acbd4c64b4cce09"
    sha256 cellar: :any_skip_relocation, catalina:      "f751b77ef2853782af49f076027d0b70870bd60a9aa678ba0acbd4c64b4cce09"
    sha256 cellar: :any_skip_relocation, mojave:        "f751b77ef2853782af49f076027d0b70870bd60a9aa678ba0acbd4c64b4cce09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18a04d0eeecc051c36f5bc9a8c02998fc47115c8bad9fbd02b4bc7dad4a24775"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".eslintrc.json").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")
    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
