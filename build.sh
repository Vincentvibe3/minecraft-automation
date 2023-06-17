echo "Building backup container"
cd backup
buildah build -t backup:latest
echo "Building management container"
cd ../management
buildah build -t management:latest
cd ../fabric
echo "Building fabric"
python3 builder.py
