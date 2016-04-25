#!/usr/bin/env bash

set -e

SOURCE_ROOT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOOLS_DIRECTORY="$SOURCE_ROOT_DIRECTORY/tools"
TARGET_BUILD_DIRECTORY="$SOURCE_ROOT_DIRECTORY/build"

function main {
  case "$1" in

  info)
    info
    ;;

  setup)
    setup
    ;;

  build)
    build
    ;;

  flash)
    flash
    ;;

  test)
    test
    ;;

  clean)
    clean
    ;;

  *)
    help
    exit 1
    ;;

  esac
}

function help {
  echo "Usage:"
  echo " info         display build information"
  echo " setup        prepares the build system (only needs to be run once)"
  echo " build        builds the application and tests"
  echo " flash        flashes the application onto the target hardware"
  echo " test         runs the test suite on the target hardware"
  echo " clean        completely removes the build system and build artifacts"
  echo " help         show this help information"
}

function info {
  echo "Source directory: $SOURCE_ROOT_DIRECTORY"
  echo "Tools directory: $TOOLS_DIRECTORY"
  echo "Target directory for target hardware: $TARGET_BUILD_DIRECTORY"
}

function setup {
  mkdir -p "$TARGET_BUILD_DIRECTORY"
  ( cd "$TARGET_BUILD_DIRECTORY" && cmake "-DCMAKE_TOOLCHAIN_FILE=$TOOLS_DIRECTORY/toolchain-arm-none-eabi.cmake" "$SOURCE_ROOT_DIRECTORY" )
}

function build {
  runTarget all
}

function flash {
  runTarget flash_firmware
}

function test {
  runTarget run_tests
}

function clean {
  rm -rf "$TARGET_BUILD_DIRECTORY"
}

function checkSetupHasBeenRun {
  if [ ! -d "$TARGET_BUILD_DIRECTORY" ]; then
    setup
  fi
}

function runTarget {
  checkSetupHasBeenRun

  ( cd "$TARGET_BUILD_DIRECTORY" && cmake "$SOURCE_ROOT_DIRECTORY" && make $1 )
}

main "$@"
