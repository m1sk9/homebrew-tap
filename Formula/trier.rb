class Trier < Formula
  desc "Open each URL in the browser its rule picks"
  homepage "https://github.com/m1sk9/trier"
  url "https://github.com/m1sk9/trier/releases/download/trier-v0.1.0/trier-aarch64-apple-darwin.tar.gz"
  sha256 "5153c3ca298817a0a25fd468a6577f3dfb4a2fb999a7d0afba4c955ba0a8af00"
  license "MIT"

  # Only an aarch64-apple-darwin archive is published: trier registers itself
  # with Launch Services, so there is no Linux build, and no Intel one.
  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "trier"
  end

  def caveats
    <<~EOS
      Run `trier register` after install and after every upgrade to (re)create
      ~/Applications/Trier.app and make it the default browser.
      Run `trier unregister` before uninstalling.
    EOS
  end

  test do
    assert_match "trier #{version}", shell_output("#{bin}/trier --version")
    assert_match "Usage:", shell_output("#{bin}/trier --help")
  end
end
