echo `date -u +"%Y-%m-%dT%H:%M:%SZ"` $2 >> /usr/local/var/hook.log
echo $1 | jq '.' > /usr/local/var/output.json
