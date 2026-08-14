class Strays < Formula
  desc "TUI for centralized management of LLM agents running on machines"
  homepage "https://github.com/m1sk9/strays"
  url "https://github.com/m1sk9/strays/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "882c42952d8a34bf7b22ed6c514c705e7f5c57fdf16d1317adbf2f3f0d9ad4b9"
  license "MIT"
  head "https://github.com/m1sk9/strays.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # strays enters the TUI at startup and exposes no --version/--help to probe,
    # so running it here would either block on a TTY or fail on an environment
    # detail rather than on the build. Assert the artifact instead.
    assert_path_exists bin/"strays"
    assert_predicate bin/"strays", :executable?
  end
end
