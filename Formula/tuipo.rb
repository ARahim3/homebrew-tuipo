class Tuipo < Formula
  desc "Grammarly-style spell-check for your terminal — underlines typos as you type in any TUI"
  homepage "https://github.com/ARahim3/tuipo"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.1.1/tuipo-aarch64-apple-darwin.tar.xz"
      sha256 "04773ada68af780eaf5b0b9146c9bfb33755bd26bf40f1cc59ae3d80498c5e77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.1.1/tuipo-x86_64-apple-darwin.tar.xz"
      sha256 "7d49eca0e8e2cf5b615ace756613837da47f0f304ae907658840e0b8a1855ef1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.1.1/tuipo-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a8937cb5119b6ff7b41022b57ca8a2f255c6ffce66df20c342e3d227f6bf4e9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.1.1/tuipo-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4174f221d5e4f06df20c851990fb6c981d3068ea4a9bdaff33004bea2d36a3d0"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "tuipo" if OS.mac? && Hardware::CPU.arm?
    bin.install "tuipo" if OS.mac? && Hardware::CPU.intel?
    bin.install "tuipo" if OS.linux? && Hardware::CPU.arm?
    bin.install "tuipo" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
