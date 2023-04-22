sudo qemu-img convert -f qcow2 -O raw ./output-qcow2/packer-qcow2 ./output-qcow2/packer-qcow2.raw
rawdisk="./output-qcow2/packer-qcow2.raw"
vhddisk="./output-qcow2/alpine.vhd"

MB=$((1024*1024))
size=$(qemu-img info -f raw --output json "$rawdisk" | \
gawk 'match($0, /"virtual-size": ([0-9]+),/, val) {print val[1]}')

rounded_size=$(((($size+$MB-1)/$MB)*$MB))

echo "Rounded Size = $rounded_size"

sudo qemu-img resize $rawdisk $rounded_size
sudo qemu-img convert -f raw -o subformat=fixed,force_size -O vpc $rawdisk $vhddisk