#!/usr/bin/env bash
# hack for Yesod
 
ghc_mod=~/.cabal/bin/ghc-mod
 
pwd=`pwd`
dir=`basename $pwd`
#set -x
EXT="-g-XHaskell98 -g-XTemplateHaskell -g-XQuasiQuotes -g-XOverloadedStrings -g-XNoImplicitPrelude -g-XCPP -g-XMultiParamTypeClasses -g-XTypeFamilies -g-XGADTs -g-XGeneralizedNewtypeDeriving -g-XFlexibleContexts -g-XEmptyDataDecls -g-XNoMonomorphismRestriction -g-XDeriveDataTypeable"

function find_config(){
		local DIR=`pwd`
		while [ ! $DIR = "/" ] ;do
				if [ -e "$DIR/cabal.sandbox.config" ];then
						echo "$DIR/cabal.sandbox.config"
						return 0
				fi
				DIR=`dirname $DIR`
		done
		echo ""
		return 1
}

function ghcmod(){
		if [ "$1" = check ] ; then
				shift
				PACKAGEDB=""
				SCONFIG=`find_config`
				if [ ! -z "$SCONFIG" ]; then
						PACKAGEDB=" $EXT -g-no-user-package-db -g-package-db="`perl -ane 'if(/package-db:(\s*)(.*)$/){print \$2}' < $SCONFIG`" "
				fi
				hdevtools check $PACKAGEDB $@ | lineconv.pl
		else
				ghc-mod  $@
		fi
}

 
if [ -e "../Handler" -a -d ../app ]  ; then
    pushd .. > /dev/null
    ghcmod $@
    popd > /dev/null
else
    ghcmod $@
fi
