class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/openexr/openexr/archive/v3.0.3.tar.gz"
  sha256 "d3526a3ccdca78a94658d5208e1963e4686181087004edd5bb98290e1fd0f389"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1daa3b79393d1b774235b3d0935b7f6d5e1a21c9b124db0858d0f069f8822b7d"
    sha256 cellar: :any,                 big_sur:       "0df22b8bfaeecf3be5d8e87f79fff487e201763d77105fd4447bd1cf273e31c7"
    sha256 cellar: :any,                 catalina:      "698d9d7a8ea4df24535d1cf79bf9b477e5633340d67cdde8fa3af1b0421d4cff"
    sha256 cellar: :any,                 mojave:        "0d962814005634bed8aba3e3827cd6bd772d22b7c3a37c83688697a7f7f58651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96120b2078fe7676e74a29a8437d1939fe22d19104afe42b87a0cd5c8993bf97"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "imath"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
