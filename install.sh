#!/bin/bash
set -e

echo "==============================="
echo "🖥️  Mazen RDP VPS Installer"
echo "==============================="

# اختيار النظام
echo ""
echo "[1] Windows 10 Lite"
echo "[2] Windows 11 Lite"
echo "[3] Windows Server 2019 Lite"
read -p "Select Windows version [1-3]: " choice

case "$choice" in
  1) img_url="https://recolic.net/hms.php?/systems/win10pro-22h2-virtio-uefi.qcow2";;
  2) img_url="https://archive.org/download/win11-lite/win11-lite.qcow2";;
  3) img_url="https://archive.org/download/win2019-lite/win2019-lite.qcow2";;
  *) echo "Invalid choice."; exit 1;;
esac

# اختيار الموارد
read -p "Enter RAM size (e.g., 4G): " ram
read -p "Enter number of CPU cores: " cpu

# اسم الملف
img_file="/root/windows-selected.qcow2"

echo "[+] Installing dependencies..."
apt-get update -y && apt-get install -y qemu-system curl wget

echo "[+] Downloading selected Windows image..."
wget -O "$img_file" "$img_url"

echo "[+] Starting Windows with RDP enabled..."
nohup qemu-system-x86_64 \
  -m "$ram" \
  -smp cores="$cpu" \
  -hda "$img_file" \
  -net user,hostfwd=tcp::3389-:3389 \
  -net nic \
  -enable-kvm \
  -nographic > /root/qemu.log 2>&1 &

# الحصول على IP الخارجي
ip=$(curl -s ifconfig.me)

echo ""
echo "======================================="
echo "✅ Windows is now running on your VPS!"
echo "📡 RDP IP: $ip"
echo "🔌 RDP Port: 3389"
echo "👤 Username: Administrator"
echo "🔑 Password: 123456"
echo "💾 Saved in: /root/rdp-info.txt"
echo "======================================="

cat <<EOF > /root/rdp-info.txt
Windows RDP is now running!

RDP IP: $ip
RDP Port: 3389
Username: Administrator
Password: 123456
EOF
