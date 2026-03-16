# dotfiles

A collection of my *nix dotfiles.

Uses [chezmoi](https://www.chezmoi.io/) for dotfile management.

## Prerequisites

**OS**: Debian like[^*]

1. Update apt: `apt-get update`
2. Install git: `apt-get install git`
3. Install chezmoi: `sh -c "$(curl -fsLS get.chezmoi.io)"`

[^*]: Tested on Ubuntu debian 24.04.2

## First use
`chezmoi init --apply https://github.com/$GITHUB_USERNAME/dotfiles.git`

> It's possible `tzdata` will need user input (region select).

## Test in docker

```bash
docker run -it --rm ubuntu:latest bash -c "
  apt-get update && apt-get install -y curl git sudo software-properties-common snapd
  sh -c \"\$(curl -fsLS get.chezmoi.io)\" -- init --apply LeskoIam 
  exec bash
"
```
