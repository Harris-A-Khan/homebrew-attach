# Homebrew Tap for Attach

This is the official Homebrew tap for [Attach](https://github.com/Harris-A-Khan/attach) (private) — a native iOS bridge for `tmux` sessions running on your Mac/Linux box, reached over Tailscale.

The tap distributes pre-built `attachd` binaries; the source repository is private.

## Install

```bash
brew tap Harris-A-Khan/attach
brew install attachd
```

Then start the daemon (LaunchAgent on macOS / systemd user unit on Linux is configured by `brew services`):

```bash
brew services start attachd     # macOS
# or simply run it foreground:
attachd start
```

## Quick install (no Homebrew)

```bash
curl -fsSL https://raw.githubusercontent.com/Harris-A-Khan/homebrew-attach/main/install.sh | bash
```

This drops `attachd` and the `attach` shim into `/usr/local/bin` (or `$ATTACHD_PREFIX/bin`) and runs `attachd version` to confirm.

## Pair an iPhone

```bash
attachd pair
```

Scan the printed QR code from the [Attach iOS app](https://github.com/Harris-A-Khan/attach) (private — TestFlight invite required) or paste the `attach://pair?…` deep link.

## Wrap an LLM CLI in a tmux pane

```bash
attach claude       # also: attach codex / attach aider / attach ollama
```

The `attach` shim forwards to `attachd wrap`, which spawns the named CLI under a pseudo-terminal, mirrors output to your pane verbatim, and tees a cleaned-up event stream to the running daemon so the iOS app can render native chat bubbles.

## Upgrade / uninstall

```bash
brew upgrade attachd
brew services stop attachd
brew uninstall attachd
brew untap Harris-A-Khan/attach
```

## Supported platforms

| OS    | arch                | binary                   |
|-------|---------------------|--------------------------|
| macOS | Apple Silicon       | `attachd-darwin-arm64`   |
| macOS | Intel               | `attachd-darwin-amd64`   |
| Linux | aarch64 / arm64     | `attachd-linux-arm64`    |
| Linux | x86_64              | `attachd-linux-amd64`    |

## Requirements

- `tmux` 3.2 or later (`brew install tmux` if you don't have it; the formula declares it as a dependency).
- A Tailnet you can reach from both the host and the iPhone (Tailscale isn't required for development, but Attach is built for it).

## Links

- [attach iOS app repo](https://github.com/Harris-A-Khan/attach) (private)
- [Releases](https://github.com/Harris-A-Khan/homebrew-attach/releases)
- [Wire protocol](https://github.com/Harris-A-Khan/homebrew-attach/blob/main/PROTOCOL.md) — published with each tap release for forward-compatibility notes.

## License

MIT, see [LICENSE](LICENSE).
