# tdscli

A simple Swift CLI for testing SQL Server connectivity via [FreeTDSKit](https://github.com/oliwonders/FreeTDSKit).

## Requirements

- macOS 26+
- Swift 6.2+
- A reachable SQL Server instance (and `sqlcmd` to seed the demo data)

## Getting started

### 1. Clone the repo

```bash
git clone https://github.com/oliwonders/tdscli.git
cd tdscli
```

### 2. Create and seed the demo database

For Azure SQL Database, create the empty `demo` database while connected to
`master`, then reconnect to `demo` to create and seed the `Product` table:

```bash
sqlcmd -S tcp:<server>.database.windows.net,1433 -d master -U <user> -P '<password>' -v DatabaseName="demo" -i Sources/create-database.sql
sqlcmd -S tcp:<server>.database.windows.net,1433 -d demo -U <user> -P '<password>' -v DatabaseName="demo" -i Sources/schema.sql
```

For local SQL Server, `Sources/schema.sql` can create the database and switch to
it automatically:

```bash
sqlcmd -S <server> -U <user> -P '<password>' -v DatabaseName="demo" -i Sources/schema.sql
```

### 3. Configure the connection

`Sources/Config.plist` is gitignored so credentials stay out of the repo. Create
it from the tracked template and fill in your details:

```bash
cp Sources/Config.plist.example Sources/Config.plist
```

```xml
<key>server</key>   <string>your-server-ip-or-hostname</string>
<key>username</key> <string>your-username</string>
<key>password</key> <string>your-password</string>
<key>database</key> <string>demo</string>
```

The plist is bundled as a SwiftPM resource, so this step is required — without it
the build fails with `Invalid Resource 'Config.plist': File not found`.

### 4. Build and run

```bash
swift run
```

Swift Package Manager resolves the FreeTDSKit dependency on the first build —
`libsybdb`, `libssl`, and `libcrypto` are bundled statically, so there is nothing
to install with Homebrew.

## What it does

On each run, tdscli prints the bundled FreeTDS version, opens a `TDSConnection`
using the values from `Config.plist`, runs a `SELECT` against `dbo.Product`,
prints each decoded row, and closes the connection.
