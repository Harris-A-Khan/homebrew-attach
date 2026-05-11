class Attachd < Formula
  desc "Host daemon for the Attach iOS app — tmux over Tailscale"
  homepage "https://github.com/Harris-A-Khan/homebrew-attach"
  version "0.1.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.2/attachd-darwin-arm64"
      sha256 "e287ee64495d68613b97f928cf06d222cf0d363d57095b2ee3204647a60a2ff5"
    end
    on_intel do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.2/attachd-darwin-amd64"
      sha256 "5212b5e2051afbfaa0e5916bd5bf9371d027ed2f8c0829a8f45746c2f4390375"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.2/attachd-linux-arm64"
      sha256 "fbd30a9bddec7a9c0f4e28368e0275debcd364bb7e162d6bdd31f6c3d34c0d20"
    end
    on_intel do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.2/attachd-linux-amd64"
      sha256 "d6932adb76fd0065d04bbcaddab75a125a78d678adc6abb002f54b0b1d19a9b0"
    end
  end

  depends_on "tmux"

  def install
    binary_name = "attachd-darwin-arm64"
    if OS.mac? && Hardware::CPU.intel?
      binary_name = "attachd-darwin-amd64"
    elsif OS.linux? && Hardware::CPU.arm?
      binary_name = "attachd-linux-arm64"
    elsif OS.linux? && Hardware::CPU.intel?
      binary_name = "attachd-linux-amd64"
    end

    bin.install binary_name => "attachd"

    (bin/"attach").write <<~SHIM
      #!/usr/bin/env bash
      exec attachd wrap "$@"
    SHIM
    chmod 0755, bin/"attach"
  end

  service do
    run [opt_bin/"attachd", "start"]
    keep_alive true
    log_path  "#{Dir.home}/.attach/attachd.log"
    error_log_path "#{Dir.home}/.attach/attachd.log"
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/attachd version")
  end
end
