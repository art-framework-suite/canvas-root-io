#!/bin/bash
########################################################################
# tidy.sh
#
# Remove generaated and temporary files annd directories.
########################################################################

# Fail on error.
set -e

# Execute in the script directory.
cd "$(dirname $(realpath ${BASH_SOURCE[0]}))"

# Clean up unwanted files.
rm -rfv lib
rm -vf gen/*~ *~ *.cpp *.cpp.o *.log *.out *.err
