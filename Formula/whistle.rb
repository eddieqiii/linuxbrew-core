require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.2.tgz"
  sha256 "fe02c63472198252187bd9504d7d42d56a7c31ad90210152d325ed20cc94cbe0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "177ef66e37b0aa265493c59b8af8ddf27d432574628217196a359c4886f776cd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
