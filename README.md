# homebrew-sqlclient

Homebrew tap for [sqlclient](https://sqlclient.eu/) — a native macOS client for
MySQL, MariaDB, PostgreSQL, SQL Server and SQLite.

## Install

```sh
brew install --cask datargo/sqlclient/sqlclient
```

That single command adds the tap and installs the app. If you prefer the two
steps separately:

```sh
brew tap datargo/sqlclient
brew install --cask sqlclient
```

## Update

```sh
brew upgrade --cask sqlclient
```

The app also updates itself. Both routes read the same `latest.json`, so they
never disagree about what the current version is.

## Uninstall

```sh
brew uninstall --cask sqlclient
```

Add `--zap` to remove the settings and the credential vault as well. The
keychain entry used for Touch ID stays: `brew` does not reach into the keychain.
Remove the entry named `sqlclient` in Keychain Access if you want it gone.

## What this repository is

One file: `Casks/sqlclient.rb`. It carries the version and the checksum of the
DMG, and both are rewritten by the release script in the main repository every
time a version ships. Please do not edit them by hand here — the change would be
overwritten by the next release.

The DMG itself is served from `dl.sqlclient.eu` and is a universal binary,
signed and notarized by Apple.
