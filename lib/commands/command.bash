#!/usr/bin/env bash
#
# description:
#   Symlink a short name to an exact version
#
# usage:
#   asdf alias <plugin> <name> [<version> | --auto | --remove]"
#   asdf alias <plugin> --auto"
#   asdf alias <plugin> [--list]"
#
# examples:
#   asdf alias java 11.0 adopt-openjdk-11.0
#   asdf alias java 11.0 --remove
#   asdf alias java --auto
#   asdf alias java --list
#   asdf alias java --remove
#
# notes:
#   Symlink a short name to an exact version. Passing a second argument of
#   --auto selects the latest patch release of the given point version. Passing
#   a first argument of auto does the same for all installed point releases.
#
# credit:
#   This was inspired by https://github.com/nodenv/nodenv-aliases
#

set -e

shopt -s nullglob

usage() {
  echo "usage"
  echo "  asdf alias <plugin> <name> [<version> | --auto | --remove]"
  echo "  asdf alias <plugin> --auto"
  echo "  asdf alias <plugin> [--list]"
}

resolve_link() {
  $(type -p greadlink readlink | head -1) "$1"
}

list() {
  local exit=1
  local link
  for link in $(echo_lines_with_symlinks ./*); do
    echo "$link => $(resolve_link "$link")"
    exit=0
  done
  return $exit
}

cleanup_invalid() {
  local version
  for version in ${1:-*}; do
    if [ -L "$version" ] && [ ! -e "$(resolve_link "$version")" ]; then
      echo "Removing invalid link from $version to $(resolve_link "$version")"
      rm "$version"
    fi
  done
}

echo_lines_with_symlinks() {
  local file
  # for file in $(ls -1dA "$@" | sort --version-sort); do
  for file in "$@"; do
    [ -L "$file" ] && echo "${file#\./}"
  done
}

echo_lines_without_symlinks() {
  local file
  # for file in $(ls -1dA "$@" | sort --version-sort); do
  for file in "$@"; do
    [ ! -L "$file" ] && echo "${file#\./}"
  done
}

sort_versions() {
  local prefix=""
  [[ $1 =~ (^[^.]*-).* ]] && prefix="${BASH_REMATCH[1]}"

  semver_sort="sort --version-sort"
  sed -e "s/^$prefix//" | $semver_sort | sed -e "s/^/$prefix/"
}

auto_for_point() {
  echo_lines_without_symlinks "$1"* | sort_versions "$1" | tail -1
  # echo_lines_without_symlinks "$1"* | sort --version-sort | tail -1
}

auto_symlink_point() {
  local auto
  auto="$(auto_for_point "$1")"
  if [ -z "$auto" ]; then
    echo "Couldn't find any versions for $1" >&2
  else
    ln -nsf "$auto" "$1"
    echo "$1 => $auto"
  fi
}

pre_releases() {
  echo_lines_without_symlinks ./*.*.*-*.* | sed -E -e 's/([0-9]+\.[0-9]+\.[0-9]+-.*)\..*/\1/' | sort -u
}

minor_releases() {
  echo_lines_without_symlinks ./*.*.* | sed -E -e 's/([0-9]+\.[0-9]+)\.[0-9]+.*/\1/' | sort -u
}

major_releases() {
  echo_lines_without_symlinks ./*.*.* | sed -E -e 's/([0-9]+)\.[0-9]+\.[0-9]+.*/\1/' | sort -u | grep -xv 0
}

recommended_aliases() {
  major_releases
  minor_releases
  pre_releases
}

reshim_plugin() {
  local plugin="$1"
  asdf reshim "$plugin"
}

abort() {
  if [ "$#" -eq 1 ]; then
    echo "asdf alias: $*"
  else
    usage
  fi
  exit 1
}

main() {
  plugin="$1"
  # alias="$2" -- not used directly
  version="$3"
  install_dir="${ASDF_DATA_DIR:-$HOME/.asdf}/installs/$plugin"

  [ ! -d "$install_dir" ] && abort "The plugin '$plugin' could not be found"
  cd "$install_dir"

  case "$#" in
    3)
      case "$2" in --*)
        case "$3" in -*) abort < <(asdf help --usage alias) ;; esac
        exec asdf alias "$1" "$3" "$2"
        ;;
      esac
      if [ -e "$2" ] && [ ! -L "$2" ]; then
        abort "Not clobbering $2"
      elif [ --remove = "$3" ]; then
        if [ -L "$2" ]; then
          rm "$2" && reshim_plugin
        else
          abort "No such alias $2"
        fi
      elif [ --auto = "$3" ]; then
        case "$2" in
          *) cleanup_invalid "$2" && auto_symlink_point "$2" && reshim_plugin ;;
            # *) abort "Don't know how to automatically alias $2" ;;
        esac
      else
        echo "$2 => $3"
        ln -nsf "$3" "$2" && reshim_plugin "$@"
      fi
      ;;

    2)
      case "$2" in
        --list)
          list
          ;;
        --auto | --all)
          cleanup_invalid
          for point in $(recommended_aliases); do
            auto_symlink_point "$point"
          done
          reshim_plugin
          ;;
        -*)
          abort
          ;;
        *)
          if [ -L "$2" ]; then
            readlink "$2"
          elif [ -d "$2" ]; then
            abort "$2 is an install, not an alias"
          elif [ -e "$2" ]; then
            abort "$2 exists but is not an alias"
          else
            abort "$2 does not exist"
          fi
          ;;
      esac
      ;;

    1) list ;;

    *) abort ;;
  esac
}

main "$@"
