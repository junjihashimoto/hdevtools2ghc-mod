#!/usr/bin/env bash

export PATH=/home/junji/.cabal/bin:$PATH

if [ "$1" = check ] ; then
    shift
    hdevtools check $@ | lineconv.pl
else
    ghc-mod  $@
fi
#ghc-mod  $@
