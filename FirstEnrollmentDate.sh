#!/bin/sh
client_id="$4" 
client_secret="$5"
url="https://xxxxxx.jamfcloud.com"

getAccessToken() {
	response=$(curl --silent --location --request POST "${url}/api/oauth/token" \
		--header "Content-Type: application/x-www-form-urlencoded" \
		--data-urlencode "client_id=${client_id}" \
		--data-urlencode "grant_type=client_credentials" \
		--data-urlencode "client_secret=${client_secret}")
	access_token=$(echo "$response" | plutil -extract access_token raw -)
	token_expires_in=$(echo "$response" | plutil -extract expires_in raw -)
	token_expiration_epoch=$(($current_epoch + $token_expires_in - 1))
}

checkTokenExpiration() {
	current_epoch=$(date +%s)
	if [[ token_expiration_epoch -ge current_epoch ]]
	then
		echo " "
	else
		#echo "No valid token available, getting new token"
		getAccessToken
	fi
}

invalidateToken() {
	responseCode=$(curl -w "%{http_code}" -H "Authorization: Bearer ${access_token}" $url/api/v1/auth/invalidate-token -X POST -s -o /dev/null)
	if [[ ${responseCode} == 204 ]]
	then
		#echo " "
		access_token=""
		token_expiration_epoch="0"
	elif [[ ${responseCode} == 401 ]]
	then
		echo "Token already invalid"
	else
		echo "An unknown error occurred invalidating the token"
	fi
}
getAccessToken


checkTokenExpiration



macName=$(systemsetup -getcomputername | awk '{print $3}')

macJSSid=$(curl -s -H 'Accept: text/xml' -H "Authorization: Bearer $access_token" $url/JSSResource/computers/name/$macName | xmllint --xpath "/computer/general/id/text()" - | awk -F '%' '{print $1}')
makedate=$(curl -s -H 'Accept: text/xml' -H "Authorization: Bearer $access_token" $url/JSSResource/computers/name/$macName > /tmp/$macName.xml )

macdate=$(cat /tmp/$macName.xml | xmllint --xpath "/general/extension_attributes/FirstEnrollmentDate/text()" -)

#awk -F "extension_attributes" '{print $1}' | awk -F "FirstEnrollmentDate" '{print $2}' | awk -F "<value>" '{print $2}' | awk -F "<" '{print $1}'  | tr -d '\n')

if [[ -z $macdate ]]; then
	firstenroll=$(cat /tmp/$macName.xml | xmllint --xpath "/computer/general/last_enrolled_date_utc/text()" - | awk -F "." '{print $1}' | tr 'T' ' ' )
else
	exit 0
fi
echo "<result>$firstenroll</result>"