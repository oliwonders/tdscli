# tdscli

A simple Swift CLI for testing SQL Server connectivity via [FreeTDSKit](https://github.com/oliwonders/FreeTDSKit).

## Requirements

- macOS 26+
- Swift 6.1+

## Setup

Clone the repo and edit `Sources/Config.plist` with your connection details:

```xml
<key>server</key>   <string>your-server-ip-or-hostname</string>
<key>username</key> <string>your-username</string>
<key>password</key> <string>your-password</string>
<key>database</key> <string>your-database</string>
```

## Build & Run

```bash
git clone https://github.com/oliwonders/tdscli.git
cd tdscli
swift run
```

Swift Package Manager will automatically resolve the FreeTDSKit dependency on first build.
