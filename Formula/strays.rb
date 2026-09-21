class Strays < Formula
  desc "TUI for centralized management of LLM agents running on machines"
  homepage "https://github.com/m1sk9/strays"
  # The macOS archive is the default spec instead of living in an `on_macos`
  # block, because a platform that resolves to no url at all leaves the formula
  # unloadable ("formula requires at least a URL"). That would break
  # `brew readall --os=all --arch=all` on the Intel runner before
  # `depends_on arch:` below ever gets the chance to refuse the install.
  url "https://github.com/m1sk9/strays/releases/download/v0.3.0/strays-aarch64-apple-darwin.tar.gz"
  sha256 "bb7859621f1244204686e8a7c3d3570be365225cf4ad5c13b24c6d309f9a40d7"
  license "MIT"

  on_macos do
    # Intel macOS was sunset upstream (m1sk9/strays#19) and no
    # x86_64-apple-darwin archive is published. With no source build to fall
    # back to, this requirement is what marks the platform unsupported instead
    # of letting an arm64 binary land on an Intel Mac.
    depends_on arch: :arm64
  end

  on_linux do
    on_intel do
      url "https://github.com/m1sk9/strays/releases/download/v0.3.0/strays-x86_64-unknown-linux-musl.tar.gz"
      sha256 "96778874c995c0abc5ff20f328dcd1121de2f4adbb2d211f447eb5cba5ed9cf3"
    end

    on_arm do
      url "https://github.com/m1sk9/strays/releases/download/v0.3.0/strays-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f3645603c400b3dd3aa4c65f750d2e94b3dd49f3397b0dfdf7b20f4fdea65565"
    end
  end

  def install
    bin.install "strays"
  end

  test do
    assert_match "strays #{version}", shell_output("#{bin}/strays --version")
    assert_match "Usage:", shell_output("#{bin}/strays --help")
  end
end
