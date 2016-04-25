#! /usr/bin/env bash

ELF_FILE=$1
ARM_GDB_EXECUTABLE=$2
OPENOCD_EXECUTABLE=$3
OPENOCD_CONFIG=$4

OPENOCD_PORT=3333

echo "Running $ELF_FILE using GDB ($ARM_GDB_EXECUTABLE) and OpenOCD ($OPENOCD_EXECUTABLE) with config $OPENOCD_CONFIG"

# Unfortunately we can't use the GDB "target remote | openocd -c 'gdb_port pipe' ..." syntax
# as that then sends all stdout to GDB - we want the board to be able to write to stdout using
# semihosting. So we have to manage the openocd process ourselves.

${OPENOCD_EXECUTABLE} -c "gdb_port ${OPENOCD_PORT}; debug_level 1" -f ${OPENOCD_CONFIG} &
OPENOCD_PID=$!

${ARM_GDB_EXECUTABLE} \
        --eval-command "target remote localhost:${OPENOCD_PORT}" \
        --eval-command "set remotetimeout 5" \
        --eval-command "monitor arm semihosting enable" \
        --eval-command "monitor reset halt" \
        --eval-command "file ${ELF_FILE}" \
        --eval-command "load" \
        --eval-command "break loop_if_end_reached" \
        --eval-command "monitor reset init" \
        --eval-command "continue" \
        --eval-command "quit" \
        --batch

kill $OPENOCD_PID
