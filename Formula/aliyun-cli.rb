class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.77",
    revision: "bc902e1400b30e618646115d8901e5ded9dfcc23"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9ac541d86d2b646dd2b57b15df1121916ba16c7d2bfd985d3b2d4d1c7550ba09"
    sha256 cellar: :any_skip_relocation, big_sur:       "43b47593924c11db498d080222eb299f1a3a3efab40ec717d2de8bd052a7f7a1"
    sha256 cellar: :any_skip_relocation, catalina:      "f2dc97ea304ec440dd0f72f792eb20c0177b9ec0e89339532a3db3a46f7db49b"
    sha256 cellar: :any_skip_relocation, mojave:        "ea066e5982cdefe3be30d57e0a9f23fc89d0d99ddc0e2053b47d936fbaad56ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edaa51c4b3171f3e4a4d7c8cc5c3894f39c58c7e0129730872a58178b0dfb847"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "metas"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"),
                          "-o", bin/"aliyun", "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
