# ROOT_JIRA_10504/gen

## Overview

This directory contains scripts and files required to regenerate the partially-pre-processed `bad.i` from `bad.h` in this directory.

## Directory structure

* `00README.md`
  This file.
* `bad.h`
  The header file from which `bad_full.i` and `bad.i` are generated.
* `bad_full.i`
  The fully-pre-processed file produced by pre-processing `bad.h` with `gen_bad_i.sh`.
* `gen_bad_i.sh`
  Script to invoke the compiler to pre-process `bad.h` and then invoke `unpreprocess.pl` to remove expansions of system and compiler headers, which may be different on different systems. A built version of Boost is required that is compatible with the compiler and standard used by the ROOT you'll be using in runit.sh, as well as that compiler. The fully-re-processed file is saved as `bad_full.i` and the partially-re-processed file is saved as `../bad.i`.
* `unpreprocess.sh`
  Script to find and remove pre-processed system and compiler headers from the pre-processed version of `bad.h`, replacing their contents with their original includes.
