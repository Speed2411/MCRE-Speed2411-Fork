#!/bin/zsh

#	  Compile PK3 for Linux/MacOS
#	  By Ashi
#	  make sure you have 7z and zsh installed on your system

NAME="SRML_MysticRealmCE"
VERSION="v0.3-indev"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

printf '=====================================================================\n' >> $SCRIPT_DIR/pk3_output.log
printf 'PK3 Compile Script for Linux/MacOS\nCreated by Ashi\n\nCurrent Directory: '$SCRIPT_DIR'\n\nCompiling' $NAME'-'$VERSION'.pk3' >> $SCRIPT_DIR/pk3_output.log

7z a $NAME-$VERSION.pk3 ./src/* -x!.bak -x!.dbs -x!.DS_Store -x!.backup1 -x!.backup2 -x!.backup3 -tzip >> $SCRIPT_DIR/pk3_output.log
printf '=====================================================================\n' >> $SCRIPT_DIR/pk3_output.log
