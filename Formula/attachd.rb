class Attachd < Formula
  desc "Host daemon for the Attach iOS app — tmux over Tailscale"
  homepage "https://github.com/Harris-A-Khan/homebrew-attach"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.0/attachd-darwin-arm64"
      sha256 "de37a44d07cfd79536b711a15414589b27b9900f0fe5b34d31fd67f038e23d7f"
    end
    on_intel do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.0/attachd-darwin-amd64"
      sha256 "174d85f80609476f48cc4686bd6b399eade24e180f20d38f1721466490039fab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.0/attachd-linux-arm64"
      sha256 "7f87bdac7bef43e416edcd1bb1e355fc8895604a47ea16b0de6ce9e6f8409abf"
    end
    on_intel do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.0/attachd-linux-amd64"
      sha256 "ca01406e250c5a93654a2444ba56c317c9f26e74a9b33442d8b214842ebc7278"
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

    # Friendly shim so users can type `attach claude` instead of
    # `attachd wrap claude`.
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
