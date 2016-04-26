#!/usr/bin/env bash

set -e

SOURCE_ROOT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOOLS_DIRECTORY="$SOURCE_ROOT_DIRECTORY/tools"
TARGET_BUILD_DIRECTORY="$SOURCE_ROOT_DIRECTORY/build/target"
HOST_BUILD_DIRECTORY="$SOURCE_ROOT_DIRECTORY/build/host"

function main {
  case "$1" in

  setup)
    setup
    ;;

  "build-host")
    buildForHost
    ;;

  "build-target")
    buildForTarget
    ;;

  flash)
    flash
    ;;

  "test-host")
    testOnHost
    ;;

  "test-target")
    testOnTarget
    ;;

  clean)
    clean
    ;;

  info)
    info
    ;;

  *)
    help
    exit 1
    ;;

  esac
}

function help {
  echo "Usage:"
  echo " setup         prepares the build system (only needs to be run once)"
  echo " build-host    builds the application and tests for this computer"
  echo " build-target  builds the application and tests for the target hardware"
  echo " flash         flashes the application onto the target hardware"
  echo " test-host     runs the test suite on this computer"
  echo " test-target   runs the test suite on the target hardware"
  echo " clean         completely removes the build system and build artifacts"
  echo " info          display build information"
  echo " help          show this help information"
}

function info {
  echo "Source directory: $SOURCE_ROOT_DIRECTORY"
  echo "Tools directory: $TOOLS_DIRECTORY"
  echo "Build system directory for target hardware: $TARGET_BUILD_DIRECTORY"
  echo "Build system directory for host (this computer): $HOST_BUILD_DIRECTORY"
}

function setup {
  setupHost

  echo
  setupTarget
}

function setupHost {
  echoWhite "Configuring build system for this computer..."
  mkdir -p "$HOST_BUILD_DIRECTORY"
  ( cd "$HOST_BUILD_DIRECTORY" && cmake "$SOURCE_ROOT_DIRECTORY" )
}

function setupTarget {
  echoWhite "Configuring build system for the target hardware..."
  mkdir -p "$TARGET_BUILD_DIRECTORY"
  ( cd "$TARGET_BUILD_DIRECTORY" && cmake "-DCMAKE_TOOLCHAIN_FILE=$TOOLS_DIRECTORY/toolchain-arm-none-eabi.cmake" "$SOURCE_ROOT_DIRECTORY" )
}

function buildForHost {
  runHostTask all
}

function buildForTarget {
  runTargetTask all
}

function flash {
  runTargetTask flash_firmware
}

function testOnHost {
  runHostTask run_tests
}

function testOnTarget {
  runTargetTask run_tests
}

function clean {
  rm -rf "$HOST_BUILD_DIRECTORY"
  rm -rf "$TARGET_BUILD_DIRECTORY"
}

function checkHostSetupHasBeenRun {
  if [ ! -d "$HOST_BUILD_DIRECTORY" ] ; then
    setupHost
  fi
}

function runHostTask {
  checkHostSetupHasBeenRun

  ( cd "$HOST_BUILD_DIRECTORY" && cmake "$SOURCE_ROOT_DIRECTORY" && make $1 )
}

function checkTargetSetupHasBeenRun {
  if [ ! -d "$TARGET_BUILD_DIRECTORY" ]; then
    setupTarget
  fi
}

function runTargetTask {
  checkTargetSetupHasBeenRun

  ( cd "$TARGET_BUILD_DIRECTORY" && cmake "$SOURCE_ROOT_DIRECTORY" && make $1 )
}

function echoWhite {
  white=$(tput setaf 7)
  reset=$(tput sgr0)

  echo "${white}$1${reset}"
}

main "$@"
