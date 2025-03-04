class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.29.7.tar.gz"
  sha256 "f3cbfece15ef3f4621aa4465d6524b5dacfd54ee59f0a13333f46e81599792b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4475e7f932fa095f2b7e75df538b0aa4ee0726bb23b5507a264cd052a71841d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "b35679842cfc64f7ef4972ba77f1d0062520c4b21f3f4d98041ad4c744a450a7"
    sha256 cellar: :any_skip_relocation, catalina:      "09cc4ad4a45668d89a6fb83f214ebe4468711480b2459967530af9ac55e42916"
    sha256 cellar: :any_skip_relocation, mojave:        "8ddd18d3790faeea51702ad93350218f017d811f3fad0d82d4877f3a32719324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eb7124097332ef326433ce529abd627f1075ca18ed78f7e45a134449d7bb76c"
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
