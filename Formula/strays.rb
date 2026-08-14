class Strays < Formula
  desc "TUI for centralized management of LLM agents running on machines"
  homepage "https://github.com/m1sk9/strays"
  url "https://github.com/m1sk9/strays/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0f24f86e2668aed8d9f15203fb25006286c6c5e435a58c09782376407d17f84c"
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
