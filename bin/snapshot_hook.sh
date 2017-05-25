echo `date -u +"%Y-%m-%dT%H:%M:%SZ"` $2 >> hook.log
echo $1 | jq '.' > output.json
