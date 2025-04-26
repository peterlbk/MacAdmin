#!/bin/zsh
if [[ -e /Applications/Falcon.app/Contents/Resources/falconctl ]]; then
CHECK1=$(/Applications/Falcon.app/Contents/Resources/falconctl stats Communications | grep -c DnsRequestMacV4)
CHECK2=$(/Applications/Falcon.app/Contents/Resources/falconctl stats Communications | grep -c NetworkConnectIP4MacV13)

if [[ $CHECK1 -gt 0 ]] || [[ $CHECK2 -gt 0 ]]; then
	echo "<result>Falcon OK</result>"
else
	echo "<result>Falcon Faulty</result>"
fi
else
	echo "<result>No Falcon</result>"
fi