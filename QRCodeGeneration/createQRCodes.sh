#!/bin/sh

source api.keys

## Takes an input file of Parse ObjectIDs
#  Then for each id, create a QR code and associate it with the device in Parse

if [ -z "$1" ]
then
	echo "Please enter file to search as first param"
	exit 1
fi

IFS=$'\n'
objectIds=( $(grep 'objectId' $1 | sed 's/"objectId"://g' | tr -s ' ' | sed 's/"//g' | sed 's/,//g') )
unset IFS

QRURL="https://api.qrserver.com/v1/create-qr-code/?size=75x75&data="
for id in ${objectIds[@]}
do
	downloadURL="${QRURL}${id}"
	filename="${id}.png"
	curl -o $filename -s $downloadURL

echo "Uploading $filename"
	nameAndURL=( $(curl -s -X POST \
		  -H "X-Parse-Application-Id: ${PARSE_APPLICATION_ID}" \
		  -H "X-Parse-REST-API-Key: ${PARSE_REST_API_KEY}" \
		  -H "Content-Type: image/png" \
		  --data-binary @$filename \
		  https://api.parse.com/1/files/$filename  | jq -c -r .name,.url) )
echo "Associating $filename with parse file: ${nameAndURL[0]}"
	curl -s -X PUT \
      -H "X-Parse-Application-Id: ${PARSE_APPLICATION_ID}" \
      -H "X-Parse-REST-API-Key: ${PARSE_REST_API_KEY}" \
	  -H "Content-Type: application/json" \
	  -d '{
		"QRCode": {
		  "name": "'${nameAndURL[0]}'",
		  "__type": "File"
		}
	      }' \
	  https://api.parse.com/1/classes/Device/${id}
done

echo "Images created succesfully!"

