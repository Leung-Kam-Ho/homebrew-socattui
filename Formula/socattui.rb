class Socattui < Formula
  include Language::Python::Virtualenv

  desc "TUI tool for managing USB serial device bridges using socat"
  homepage "https://github.com/Leung-Kam-Ho/SocatTUI"
  url "https://github.com/Leung-Kam-Ho/SocatTUI/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6b561065c4dd95c6e273b3102e0860b600b576f0cd68b959050fb213236f5419"
  license "MIT"

  depends_on "python@3.12"
  depends_on "socat"

  def install
    virtualenv_create(libexec, "python3.12")
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/socattui", "--help"
  end
end
