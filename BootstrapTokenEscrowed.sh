#!/bin/sh

bootstrap=$(profiles status -type bootstraptoken)
if [[ $bootstrap == *"escrowed to server: YES"* ]]; then
	echo "YES, Bootstrap escrowed"
 	result="YES"
else
	echo "NO, Bootstrap not escrowed"
	result="NO"
fi
echo "<result>$result</result>"

# may be extended with https://github.com/robjschroeder/Bootstrap-Token-Escrow