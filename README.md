# dotfiles <!-- omit in toc -->

> This repository contains my own macOS configuration. The scripts are not written to work for everybody, due to some absolute paths, but you can take inspiration to see how I work or reuse some of the bash functions and snippets.

[![Open Issues](https://badgen.net/github/open-issues/longpdo/dotfiles)](https://github.com/longpdo/dotfiles/issues)
[![License](https://badgen.net/github/license/longpdo/dotfiles)](LICENSE)

<!-- TABLE OF CONTENTS -->
## Table of Contents <!-- omit in toc -->

* [About The Project](#about-the-project)
  * [Directory structure](#directory-structure)
  * [Scripts](#scripts)
    * [Brew Scripts](#brew-scripts)
    * [Daily Scripts](#daily-scripts)
    * [Git Scripts](#git-scripts)
    * [PDF Scripts](#pdf-scripts)
    * [Remaining Scripts](#remaining-scripts)
* [Getting Started](#getting-started)
* [Usage](#usage)
* [Manual Changes](#manual-changes)
* [Work Related Manual Changes](#work-related-manual-changes)
* [License](#license)

<!-- About The Project -->
## About The Project

This repository includes greatly customized [zsh](http://zsh.sourceforge.net/) with [Antibody](https://github.com/getantibody/antibody) featuring auto-completion, [syntax highlighting](https://github.com/zdharma/fast-syntax-highlighting), [autopair](https://github.com/hlissner/zsh-autopair) and a [Pure](https://github.com/sindresorhus/pure) [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme. Also, a one-liner install leverages Brew and mackup to setup an entire macOS environment.

### Directory structure

* `config` contains the configurations files, e.g. for **zsh** and **git**.
  * Other configurations files are backed up via [mackup](https://github.com/lra/mackup)

> Preview of iTerm2 with Pure theme running the [history-search-multi-word](https://github.com/zdharma/history-search-multi-word) zsh plugin

![iTerm Preview](/img/iterm.png)

* `scripts` contains my common used shell scripts.
  * My workflow uses the self-written `fzf-script-launcher` function to quickly call every binary inside the *scripts* folder (except the scripts inside *_templates* and *setup* folders).
  * Keybinding of the shell widget for the `fzf-script-launcher` function is Ctrl + X
  * Scripts are all linted using [shellcheck](https://github.com/koalaman/shellcheck).
  * Warning: **Do not just run any script blindly, check what they do first.**

> Demo of the `fzf-script-launcher` browsing through the available scripts and using the selected git-log.sh afterwards

![fzf script launcher](/img/fzf-script-launcher.gif)

### Scripts

#### Brew Scripts

| Script            | Description
| ----------------- | -----------
| brew-cask.sh      | Browse all available brew casks with options to install / uninstall / open the webpage
| brew-install.sh   | Browse all available brew formulas with the option to install selected brews
| brew-uninstall.sh | Browse all installed brew formulas with the option to uninstall selected brews

#### Daily Scripts

| Script                  | Description
| ----------------------- | -----------
| _cronjob.sh             | Runs all daily scripts, configured with crontab to run automatically at 23:30
| backup.sh               | Backing up current configurations with mackup
| cleanup.sh              | Cleaning up tmp files
| rebuild-github-pages.sh | Trigger new builds for repositories deployed on Github Pages
| update.sh               | Updating software packages (brews, casks, antibody plugins, App Store apps, Ruby gems)

#### Git Scripts

| Script                  | Description
| ----------------------- | -----------
| git-add.sh              | Add files interactively to git version control
| git-checkout-branch.sh  | Checkout branch from a list of local and remote branches
| git-cleanup-branches.sh | Remove local branches, which do not exist on remote anymore
| git-diff.sh             | Show changes of current modified files to their version at HEAD
| git-ignore.sh           | Create .gitignore template file pulled from gitignore.io
| git-log.sh              | Browse through git commit log
| git-unstage.sh          | Unstage files interactively from the next commit

#### PDF Scripts

| Script                      | Description
| --------------------------- | -----------
| _cronjob-get-pdfs.sh        | Runs every 30 min to check synced Dropbox folders for new files and move them
| rename-broker-statements.sh | Rename broker statements and move/sort them to the right folder

#### Remaining Scripts

| Script                | Description
| --------------------- | -----------
| chmod-x-scripts.sh    | Change sh scripts with 644 permissions to 755 permissions
| extract-archives.sh   | Extract all archives found in the working directory and remove them afterwards
| remove-media.sh       | Remove media files when the duration of the file is shorter than _DURATION in seconds
| setup-flutter.sh      | Setup complete Flutter development environment
| shellcheck-scripts.sh | Analyse all shell scripts at dotfiles/scripts with ShellCheck

<!-- GETTING STARTED -->
## Getting Started

1: Fork the repository (using the `Fork` button at the top)

2: Clone the repository

```sh
# Replace {YOUR_USERNAME} with your actual username
git clone https://github.com/{YOUR_USERNAME}/dotfiles.git
```

<!-- USAGE EXAMPLES -->
## Usage

Inside the `scripts/setup` folder I have some scripts to quickly setup my entire dev environment with all necessary software and configurations from a fresh macOS installation. There are four basic setup scripts:

* `init.sh` - installs macOS software updates, [Xcode](https://developer.apple.com/xcode/), [Homebrew](https://brew.sh/), [Dropbox](https://www.dropbox.com/)
* `brew.sh` - installs [zsh](http://zsh.sourceforge.net/) and [brew](https://formulae.brew.sh/formula/), [brew cask](https://formulae.brew.sh/cask/), **npm** and **ruby** packages
* `macos.sh` - setting configurations for macOS applications like *Preferences*, *Dock*, *Finder*, *Mail*, *SystemUIServer*, etc.
* `config.sh` - setting configurations for remaining applications

One-liner to setup everything. This will run all four scripts.

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
