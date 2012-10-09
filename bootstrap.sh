#!/usr/bin/env bash
#
# This script will bootstrap you and your mamma's OSX

function info { echo  -e "\033[1;36m=> $1\033[0m"; }
function success { echo  -e "\033[32m=> $1\033[0m"; }
function error { echo  -e "\033[31m=> $1\033[0m"; }

check_dependency()
{
  # is it installed?
  local i=true
  command -v $1 > /dev/null || i=false

  # do we have a version that will work?
  if $i; then
    # grab our version
    local version=$($1 --version | grep -oE -m 1 "\d+(.\d+)?(.\d+)?(.\d+)?" | head -1)
    # chop our version by the length of the required version
    local real_version=${version:0:${#2}}
    if [[ $2 == $real_version || $2 < $real_version ]]; then
      success "$1 installed and an acceptable version!"
    else
      error "$1 installed, but version too low; expected >= $2, got $version"
    fi
  else
    error "$1 is not installed, bailing out..."
    exit 1
  fi
}

info "checking prerequisites..."

check_dependency "git" "1.7"
check_dependency "ruby" "1.8"

info "checking for existing dotfiles directory..."

if [ -d ~/.dotfiles ]; then
  info "~/.dotfiles already exists..."
  info "updating..."
  cd ~/.dotfiles
  git pull origin master || { error "Update failed." ; exit 1 ; }

  info "installing..."
  rake install
else
  info "~/.dotfiles doesn't exist..."
  info "downloading..."
  git clone --recursive git://github.com/gaahrdner/dotfiles.git ~/.dotfiles || { error "Download failed." ; exit 1 ; }
  cd ~/.dotfiles
  success ".dotfiles downloaded"

  info "installing..."
  rake install
fi

info ".dotfiles installed"
