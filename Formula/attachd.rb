class Attachd < Formula
  desc "Host daemon for the Attach iOS app — tmux over Tailscale"
  homepage "https://github.com/Harris-A-Khan/homebrew-attach"
  version "0.1.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.4/attachd-darwin-arm64"
      sha256 "0fa709f3faf6617438e4ca13002677f0592f5ed560ff80e7e53404ea7f0d32a7"
    end
    on_intel do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.4/attachd-darwin-amd64"
      sha256 "5dc5f5f46e5a3e26bc7274cd66e08bc90385254298410bc2b21a012da60c12a8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.4/attachd-linux-arm64"
      sha256 "22c04d701af4e4ddf99fceaf621339538c69a132ef820cff3201a681575561c9"
    end
    on_intel do
      url "https://github.com/Harris-A-Khan/homebrew-attach/releases/download/v0.1.4/attachd-linux-amd64"
      sha256 "dce9b5a031c117c376c90bfea3cc09d728bb07264657aac143752a232455de03"
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
