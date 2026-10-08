class Tuipo < Formula
  desc "Grammarly-style spell-check for your terminal — underlines typos as you type in any TUI"
  homepage "https://github.com/ARahim3/tuipo"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.2.0/tuipo-aarch64-apple-darwin.tar.xz"
      sha256 "ed795ad8d7538e697397e8bcac5fac3852b6bb1fc8a4f5f9ebb9cf639e5af091"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.2.0/tuipo-x86_64-apple-darwin.tar.xz"
      sha256 "97871f1b4c4ed8efd109ee5eb39387f6c5cad750fb0e164f32b9601cb63acc51"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.2.0/tuipo-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d4cca83a998ecce0360f40d7a95e368004ec98105775d190685145d10fd654f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.2.0/tuipo-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c36153cf0d5c6f06c9b398c621edd7de8332ad1d3c4359240d776cc6bd827a9e"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "tuipo"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tuipo"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tuipo"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tuipo"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
