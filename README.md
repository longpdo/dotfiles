# dotfiles

> This repository contains my own macOS configuration. The scripts are not written to work for everybody, since some paths point to my Dropbox but you can take inspiration to see how I work and reuse code snippets.

## How to run

```bash
# Run this command inside the dotfiles repository
./setup.sh all
```

## Manual changes

- Deactivate automatic screen brightness for the retina display
- Never deactivate monitor if plugged in
- Requiring password immediately after sleep begins (defaults write does not work since macOS 10.13.4)
- Battery Monitor settings
- Finder: remove (recently used, icloud, tags, cds, bonjour-computer) from the sidebar

- Install [Flutter SDK](https://flutter.dev/docs/get-started/install/macos)
- Install Android SDK via Android Studio

## Work related manual changes

- Add work signature to mail
