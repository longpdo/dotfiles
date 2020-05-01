# dotfiles <!-- omit in toc -->

> This repository contains my own macOS configuration. The scripts are not written to work for everybody, since some paths point to my Dropbox, but you can take inspiration to see how I work or reuse some of the bash functions and snippets.

[![Open Issues](https://badgen.net/github/open-issues/longpdo/dotfiles)](https://github.com/longpdo/dotfiles/issues)
[![License](https://badgen.net/github/license/longpdo/dotfiles)](LICENSE)

<!-- TABLE OF CONTENTS -->
## Table of Contents <!-- omit in toc -->

* [About The Project](#about-the-project)
* [Getting Started](#getting-started)
* [Usage](#usage)
* [Manual Changes](#manual-changes)
* [Work Related Manual Changes](#work-related-manual-changes)
* [License](#license)

<!-- About The Project -->
## About The Project

There are five basic setup scripts:

* `init.sh` - installs macOS software updates, [Xcode](https://developer.apple.com/xcode/), [Homebrew](https://brew.sh/), [Dropbox](https://www.dropbox.com/)
* `brew.sh` - installs [zsh](http://zsh.sourceforge.net/) and *brew*, *brew cask*, *npm* and *ruby* packages
* `macos.sh` - setting configurations for macOS applications like *Preferences*, *Dock*, *Finder*, *Mail*, *SystemUIServer*, etc.
* `config.sh` - setting configurations for remaining applications

<!-- GETTING STARTED -->
## Getting Started

To get a local copy, clone the repository.

```sh
git clone https://github.com/longpdo/dotfiles.git
```

<!-- USAGE EXAMPLES -->
## Usage

One-liner to setup everything. This will run all five scripts.

```bash
./setup.sh all
```

To exclude the execution of one script, exclude it from the arguments.

```bash
# e.g. to just install software - run only init and brew
./setup.sh init brew
```

## Manual Changes

* Deactivate automatic screen brightness for the retina display
* Never deactivate monitor if plugged in
* Requiring password immediately after sleep begins (defaults write does not work since macOS 10.13.4)
* Finder: remove (recently used, iCloud, tags, cds, bonjour-computer) from the sidebar

## Work Related Manual Changes

* Add work signature to mail

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.
