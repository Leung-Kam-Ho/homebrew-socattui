class Socattui < Formula
  include Language::Python::Virtualenv

  desc "TUI tool for managing USB serial device bridges using socat"
  homepage "https://github.com/Leung-Kam-Ho/SocatTUI"
  url "https://github.com/Leung-Kam-Ho/SocatTUI/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6b561065c4dd95c6e273b3102e0860b600b576f0cd68b959050fb213236f5419"
  license "MIT"

  depends_on "python@3.12"
  depends_on "socat"

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/56/49/2797ec0ef88008a653a8867bb8d1e5c223cd2df8e40390dd5c6a0279cbc5/hatchling-1.30.1-py3-none-any.whl"
    sha256 "161eacafb3c6f91526e92116d21426369f2c36e98c36a864f11a96345ad4ee31"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resource("hatchling")
    venv.pip_install buildpath, build_isolation: false
  end

  test do
    system "#{bin}/socattui", "--help"
  end
end
