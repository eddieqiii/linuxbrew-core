class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.14/pandoc-2.14.tar.gz"
  sha256 "88eda1e01828da310429b3cbfbdb5ff80ccfbc0d7158f88c41e9c409ebb3f9c2"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "b62fcbc0b2edec0566ce554070ebd891f2072576fd2cd38eb98325760958404c"
    sha256 cellar: :any_skip_relocation, catalina:     "193915dd53c8d11863b6c874220fae89e44c3c44a59d60c53190b81e15b89324"
    sha256 cellar: :any_skip_relocation, mojave:       "2e24634d0c05f6e04ac23bce38fc3c0157fe4a25d7675e47424875f51c33ee8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8e02e8cd148f57147b30fa722152d0ab319650f6430ebfccb2c57a65d05254e7"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
    man1.install "man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
