# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Build and run
swift run

# Build only
swift build

# Run tests (none currently defined)
swift test
```

## Architecture

**tdscli** is a minimal Swift CLI (target name: `tdscli2`) that tests SQL Server connectivity via [FreeTDSKit](https://github.com/oliwonders/FreeTDSKit).

### Flow

1. `main.swift` loads `Config.plist` from the app bundle at runtime
2. Creates a `TDSConnection` using the loaded credentials
3. Executes a spatial query against SQL Server
4. Decodes rows into `SpatialRow` (Decodable struct in `SpatialRow.swift`)
5. Closes the connection asynchronously

### Key details

- **Config:** Connection credentials live in `Sources/Config.plist`, which is bundled as a resource (see `Package.swift`). Edit this file before running.
- **No system dependencies:** FreeTDSKit bundles `libsybdb`, `libssl`, and `libcrypto` statically — `swift run` works out of the box with no Homebrew installs required.
- **Concurrency:** Uses Swift async/await throughout; the top-level `await` in `main.swift` drives the async entry point.
- **Dependency pinning:** FreeTDSKit tracks the `main` branch (not a tagged release); `Package.resolved` holds the pinned revision.
