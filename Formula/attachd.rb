class Attachd < Formula
  desc "Host daemon for the Attach iOS app — tmux over Tailscale"
  homepage "https://github.com/Harris-A-Khan/homebrew-attach"
  version "0.1.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.3/attachd-darwin-arm64"
      sha256 "0bb21d7e5e969528775d16a638d4aa8012861bdc7bacf0a294bc283cfc7b2296"
    end
    on_intel do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.3/attachd-darwin-amd64"
      sha256 "f799c31c78854e83bf333a3728185e7645e498a9d74f26673f36948d1af056b6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.3/attachd-linux-arm64"
      sha256 "890b4aed1e80d7816a54597e99fb65d19cb65b9fe9b91c958f8cf9b82cef1136"
    end
    on_intel do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.3/attachd-linux-amd64"
      sha256 "e8a13a6c0e86bdca4810ebda9fd31043d9d817e5369a5001bcdd0a4412475164"
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
