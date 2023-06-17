# world name, version
podman pod create --userns=keep-id --replace -p 25565:25565/tcp -p 25565:25565/udp -p 3000:3000 "pod_$1_fabric_$2"
podman run -d --replace --pod "pod_$1_fabric_$2" --name "$1_fabric_$2" -e eula=true -v "$1:/home/server/data:U" "fabric:$2"
podman run -d --replace --pod "pod_$1_fabric_$2" --name "$1_fabric_$2_management" -v "$1:/home/workspace/data:U" management:latest