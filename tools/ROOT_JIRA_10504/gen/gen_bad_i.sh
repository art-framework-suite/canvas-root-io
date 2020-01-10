#!/bin/bash
########################################################################
# gen_bad_i.sh
#
# Generate a partially-re-processed file ../bad.i from bad.h.
########################################################################

# Ascertain script directory.
script_dir=$(dirname $(realpath ${BASH_SOURCE[0]}))

# Execute in script directory.
cd $script_dir || exit 1

# Require UPS and Boost.
[[ -n "${SETUP_UPS}" ]] || exit 1
ups_topdir=${SETUP_UPS##*-z}
. "${ups_topdir## }"/setup || exit 1
setup -B boost v1_70_0 -q+e19:+debug || exit 1

# Fail on error.
set -e

# Generate a fully-re-processed file bad_full.i from bad.h.
g++ -Wall -Wextra -pedantic -Werror ${BOOST_INC+-I$BOOST_INC} -std=c++17 -E bad.h > bad_full.i

# Remove expanded system and compiler headers and replace with original includes.
perl -wn ${script_dir}/unpreprocess.pl bad_full.i > ../bad.i
