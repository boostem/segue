#!/usr/bin/env bash
# build.sh: check tools, then build, test, run or install segue.
#
#   ./build.sh              debug build (ASan + UBSan), then run the tests
#   ./build.sh test         same as above
#   ./build.sh play [args]  debug build, then run segue_play
#   ./build.sh release      optimized build in build/release/
#   ./build.sh install      release build, then install to ~/.local
#                           (PREFIX=/some/path ./build.sh install to change it)
#   ./build.sh uninstall    remove what install put there
#   ./build.sh format       clang-format our code (not third_party/)
#   ./build.sh clean        delete build/
#
# segue needs only a C compiler, CMake and make. There are no libraries to
# install: miniaudio is vendored in third_party/ and finds the system's audio
# (PipeWire, PulseAudio or ALSA on Linux; Core Audio on macOS) at runtime.

set -euo pipefail
cd "$(dirname "$0")"

usage () {
  sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'
}

have () {
  command -v "$1" >/dev/null 2>&1
}

#############################################
# Tools

missing=()

check_tools () {
  missing=()
  have cc || have gcc || have clang || missing+=("a C compiler")
  have cmake || missing+=("cmake")
  have make || have ninja || missing+=("make")
}

install_cmd () {
  if have pacman; then
    echo "sudo pacman -S --needed base-devel cmake"
  elif have apt-get; then
    echo "sudo apt-get install -y build-essential cmake"
  elif have dnf; then
    echo "sudo dnf install -y gcc make cmake"
  elif have brew; then
    echo "brew install cmake"
  fi
}

ensure_tools () {
  check_tools
  if [ ${#missing[@]} -eq 0 ]; then
    return 0
  fi

  echo "Missing: ${missing[*]}"

  local cmd
  cmd=$(install_cmd)
  if [ -z "$cmd" ]; then
    echo "Install them with your package manager, then rerun ./build.sh." >&2
    exit 1
  fi

  echo "To install them: $cmd"
  if [ -t 0 ]; then
    local reply
    read -r -p "Run that now? [y/N] " reply
    if [[ $reply =~ ^[Yy]$ ]]; then
      sh -c "$cmd"
      check_tools
      if [ ${#missing[@]} -eq 0 ]; then
        return 0
      fi
      echo "Still missing: ${missing[*]}" >&2
    fi
  fi
  exit 1
}

#############################################
# Build

# build <CMAKE_BUILD_TYPE> <dir under build/>
build () {
  local dir="build/$2"
  if [ ! -f "$dir/CMakeCache.txt" ]; then
    cmake -S . -B "$dir" -DCMAKE_BUILD_TYPE="$1"
  fi
  cmake --build "$dir" -j
}

prefix="${PREFIX:-$HOME/.local}"

cmd="${1:-test}"
if [ $# -gt 0 ]; then
  shift
fi

case "$cmd" in
  test)
    ensure_tools
    build Debug debug
    ctest --test-dir build/debug --output-on-failure
    ;;

  play)
    ensure_tools
    build Debug debug
    ./build/debug/segue_play "$@"
    ;;

  release)
    ensure_tools
    build Release release
    ;;

  install)
    ensure_tools
    build Release release
    cmake --install build/release --prefix "$prefix"
    case ":$PATH:" in
      *":$prefix/bin:"*) ;;
      *)
        echo
        echo "Note: $prefix/bin isn't on your PATH."
        echo "  fish: fish_add_path $prefix/bin"
        echo "  bash: echo 'export PATH=\"$prefix/bin:\$PATH\"' >> ~/.bashrc"
        ;;
    esac
    ;;

  uninstall)
    manifest=build/release/install_manifest.txt
    if [ ! -f "$manifest" ]; then
      echo "Nothing to uninstall: $manifest doesn't exist." >&2
      exit 1
    fi
    # The manifest has no trailing newline, so also handle a last partial line
    while IFS= read -r file || [ -n "$file" ]; do
      rm -fv "$file"
    done < "$manifest"
    rm -f "$manifest"
    ;;

  format)
    if ! have clang-format; then
      echo "clang-format not found. On CachyOS: sudo pacman -S --needed clang" >&2
      exit 1
    fi
    scripts/format.sh "$@"
    ;;

  clean)
    rm -rf build
    ;;

  -h | --help | help)
    usage
    ;;

  *)
    usage
    exit 1
    ;;
esac
