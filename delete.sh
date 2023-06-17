#world name, version
podman pod rm -f pod_$1_fabric_$2
podman volume rm $1