# world name, version, backups directory
podman run -d --replace --rm  --name "$1_fabric_$2_backup" -v "$1:/home/data:U" -v "$3:/home/backups" backup:latest backup $1 $2