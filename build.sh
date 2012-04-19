#!/bin/bash

# Positioning in the right dir
OLDPWD="$PWD"
NEWPWD="$PWD""/"$(dirname "$0")"/"
cd "$NEWPWD"

# Feedback
echo "Wait..."

# Global vars
SCRIPTNAME="LauncherMaker"
SRC="src/"
BIN="bin/"
ANN="InfoAnnotations"
SET="WindowsSettings"
COD="MainCode"
TRA="Translations/"
DOC="HelpDoc"
VAR="GenericVars"

# Read from the standard input and convert newline to "\n"
function escapeNewline {
	local LINE
	while read LINE; do
		echo -n "$LINE""\n";
	done
}

# Function that compose the script. Parameter: language
function buildScript {
	local LAN="$1"

	echo "#!/bin/bash"

	# Annotations
	echo "#~ Script: ""$SCRIPTNAME"
	sed 's/^/#~ /' "$SRC""$ANN"

	# Settings
	sed '/^$/d;/^\s*#/d' "$SRC""$SET"

	# Compose the var ZEN_INFO_TEXT
	local SEPARATOR="------------------------"
	local ANNOTATIONS=$(escapeNewline < "$SRC""$ANN" | sed 's/"/\\"/g')
	local HELP=$(escapeNewline < "$SRC""$TRA""$LAN""/""$DOC" | sed 's/"/\\"/g')
	echo "ZEN_INFO_TEXT=\"""$SCRIPTNAME""\n""$SEPARATOR""\n""$ANNOTATIONS""$SEPARATOR""\n""$HELP""\""

	# Other translated vars
	sed '/^$/d;/^\s*#/d' "$SRC""$TRA""$LAN""/""$VAR"

	# Main code
	sed '/^$/d;/^\s*#/d' "$SRC""$COD"
}

if [ ! -e "$BIN" ]; then
	mkdir "$BIN"
fi
# Cycle through the translations dirs
for I in $(ls "./src/Translations/"); do
	if [ ! -e "$BIN$I" ]; then
		mkdir "$BIN""$I"
	fi
	# Create final script and make it executable
	buildScript $I > "$BIN""$I""/""$SCRIPTNAME"
	chmod +x "$BIN""$I""/""$SCRIPTNAME"
done

# Feedback
echo "Done!"

# Restore old path
cd "$OLDPWD"
