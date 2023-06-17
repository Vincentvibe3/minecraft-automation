# world name, version, backup to restore
podman run -d --replace --rm \
	--name "$1_fabric_restore" \
	-v "$1:/home/data:U" \
	--mount "type=bind,source=$2,target=/home/backups/backup.tar.gz" \
	backup:latest restore $1