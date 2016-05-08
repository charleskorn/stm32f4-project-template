#! /usr/bin/env bash

ELF_FILE=$1
ARM_GDB_EXECUTABLE=$2
OPENOCD_EXECUTABLE=$3
OPENOCD_CONFIG=$4

OPENOCD_PORT=3333

white=$(tput setaf 7)
green=$(tput setaf 2)
red=$(tput setaf 1)
reset=$(tput sgr0)

echo "${white}Running $ELF_FILE using GDB ($ARM_GDB_EXECUTABLE) and OpenOCD ($OPENOCD_EXECUTABLE) with config ${OPENOCD_CONFIG}${reset}"

TEST_OUTPUT_FILE=$(mktemp)

# Unfortunately we can't use the GDB "target remote | openocd -c 'gdb_port pipe' ..." syntax
# as that then sends all stdout to GDB - we want the board to be able to write to stdout using
# semihosting. So we have to manage the openocd process ourselves.

${OPENOCD_EXECUTABLE} -c "gdb_port ${OPENOCD_PORT}; debug_level 1" -f $OPENOCD_CONFIG > >(tee $TEST_OUTPUT_FILE) &
OPENOCD_PID=$!

${ARM_GDB_EXECUTABLE} \
        --eval-command "echo ${white}Connecting to OpenOCD...\n${reset}" \
        --eval-command "target remote localhost:${OPENOCD_PORT}" \
        --eval-command "echo ${white}Configuring session...\n${reset}" \
        --eval-command "set remotetimeout 5" \
        --eval-command "monitor arm semihosting enable" \
        --eval-command "monitor reset halt" \
        --eval-command "echo ${white}Loading tests...\n${reset}" \
        --eval-command "file ${ELF_FILE}" \
        --eval-command "load" \
        --eval-command "break loop_if_end_reached" \
        --eval-command "monitor reset init" \
        --eval-command "echo ${white}Starting tests...\n${reset}" \
        --eval-command "continue" \
        --eval-command "echo ${white}Test run completed.\n${reset}" \
        --eval-command "quit" \
        --batch

kill $OPENOCD_PID

# Wait for OpenOCD to quit, and don't display the 'terminated job' message.
wait $OPENOCD_PID 2>/dev/null

grep -xq '\x1B\[1;32mSuccess!\x1B\[0m' $TEST_OUTPUT_FILE
SEARCH_RESULT=$? # grep returns 0 if a match is found, 1 if no match is found and something greater than 1 if an error occurs

rm $TEST_OUTPUT_FILE

if [[ $SEARCH_RESULT -eq 0 ]]; then
    echo "${green}All tests passed.${reset}"
    exit 0
else
    echo "${red}One or more tests failed or the test run did not complete successfully. See above for details.${reset}"
    exit 1
fi
