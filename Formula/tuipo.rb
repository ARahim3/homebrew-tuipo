class Tuipo < Formula
  desc "Grammarly-style spell-check for your terminal — underlines typos as you type in any TUI"
  homepage "https://github.com/ARahim3/tuipo"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.1.0/tuipo-aarch64-apple-darwin.tar.xz"
      sha256 "855cb8f39efa6a083b42a6b89cfab28da732c8786f487e82e4dbab4ea9ddcdae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.1.0/tuipo-x86_64-apple-darwin.tar.xz"
      sha256 "aaa727c76292aad6fbcde5f95175b03d7e4a3382db622432ec8be14276a6e7e1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.1.0/tuipo-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "144a0d01f1c69ea7767aaf75aeb2d97b4ad6dcfdfde56a7249c20811dec91baa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.1.0/tuipo-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "75f332bcdae59c6f6302a595bc9d9042af89329efff0631255101533d6bee18c"
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
