# DevMac
A toolset to bootstrap a full customizable macOS development system. This does not assume you're doing web development but installs the minimal set of software every macOS developer will want.

## Introduction


## Features
- Enables the macOS application firewall (for better security)
- Enables full-disk encryption and saves the FileVault Recovery Key to the Desktop (for better security)
- Installs the Xcode Command Line Tools (for compilers and Unix tools)
- Agree to the Xcode license (for using compilers without prompts)
- Installs the latest macOS software updates (for better security)
- Installs [Homebrew](http://brew.sh) (for installing command-line software)
- Installs [Homebrew Services](https://github.com/Homebrew/homebrew-services) (for managing Homebrew-installed services)
- Installs [Homebrew Cask](https://github.com/caskroom/homebrew-cask) (for installing graphical software)
- Idempotent

## Quick Start

Run the following command in your Terminal to install and bootstrap DevMac:

```bash
curl -s https://raw.githubusercontent.com/joheinemann/devmac/master/install.sh | bash

```
