class Tuipo < Formula
  desc "Grammarly-style spell-check for your terminal — underlines typos as you type in any TUI"
  homepage "https://github.com/ARahim3/tuipo"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.1.2/tuipo-aarch64-apple-darwin.tar.xz"
      sha256 "5a636bc9c5c3711b14e1647e646a5ea47b91296fe13cd74f9c5bc0a2dc017566"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.1.2/tuipo-x86_64-apple-darwin.tar.xz"
      sha256 "9c5df7510f071e40f3df87ed0d842050dd62c3d7ad71a7ef4aa16e4836930583"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.1.2/tuipo-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "342eec4c7186f919d96851041d7b42fc5760e3e98e6b6c7998af50a6784abf0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ARahim3/tuipo/releases/download/v0.1.2/tuipo-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4d12a3d1dd63f642a61d6d97bc99967d94daa4f720e344702809020eb1d09b3a"
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
