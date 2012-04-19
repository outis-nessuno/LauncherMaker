#!/bin/bash

OLDPWD="$PWD"
NEWPWD="$PWD""/"$(dirname "$0")"/"
cd "$NEWPWD"

echo "Wait..."

SCRIPTNAME="LauncherMaker"
SRC="src/"
BIN="bin/"
ANN="InfoAnnotations"
SET="WindowsSettings"
COD="MainCode"
TRA="Translations/"
DOC="HelpDoc"
VAR="GenericVars"

# Read from the standard input
function escapeNewline {
	local LINE
	while read LINE; do
		echo -n "$LINE""\n";
	done
}

# Parameter: language
function buildScript {
	local LAN="$1"

	echo "#!/bin/bash"
	echo "#~ Script: ""$SCRIPTNAME"
	sed 's/^/#~ /' "$SRC""$ANN"
	sed '/^$/d;/^\s*#/d' "$SRC""$SET"

	# Compose the var ZEN_INFO_TEXT
	local SEPARATOR="------------------------"
	local ANNOTATIONS=$(escapeNewline < "$SRC""$ANN" | sed 's/"/\\"/g')
	local HELP=$(escapeNewline < "$SRC""$TRA""$LAN""/""$DOC" | sed 's/"/\\"/g')
	echo "ZEN_INFO_TEXT=\"""$SCRIPTNAME""\n""$SEPARATOR""\n""$ANNOTATIONS""$SEPARATOR""\n""$HELP""\""

	sed '/^$/d;/^\s*#/d' "$SRC""$TRA""$LAN""/""$VAR"

	sed '/^$/d;/^\s*#/d' "$SRC""$COD"
}

if [ ! -e "$BIN" ]; then
	mkdir "$BIN"
fi
for I in $(ls "./src/Translations/"); do
	if [ ! -e "$BIN$I" ]; then
		mkdir "$BIN""$I"
	fi
	buildScript $I > "$BIN""$I""/""$SCRIPTNAME"
	chmod +x "$BIN""$I""/""$SCRIPTNAME"
done

echo "Done!"

cd "$OLDPWD"
