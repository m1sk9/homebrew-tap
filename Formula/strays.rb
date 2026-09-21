class Strays < Formula
  desc "TUI for centralized management of LLM agents running on machines"
  homepage "https://github.com/m1sk9/strays"
  url "https://github.com/m1sk9/strays/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "1c69b84f41e662cb3a45b8ff1a0111e1ae4aac901aac43466ec96d3979ce8ad0"
  license "MIT"
  head "https://github.com/m1sk9/strays.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "strays #{version}", shell_output("#{bin}/strays --version")
    assert_match "Usage:", shell_output("#{bin}/strays --help")
  end
end
