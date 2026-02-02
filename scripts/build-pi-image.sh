#!/bin/bash
# NullSec Linux Pi Image Builder
# https://github.com/bad-antics/nullsec-linux-pi

set -e

VERSION="1.0.0"
ARCH="${1:-arm64}"
EDITION="${2:-full}"
OUTPUT_DIR="./output"

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║           NullSec Linux Pi Edition Builder v${VERSION}           ║"
echo "╚═══════════════════════════════════════════════════════════════╝"

# Check dependencies
check_deps() {
    local deps=(debootstrap qemu-user-static binfmt-support parted kpartx)
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            echo "[!] Missing: $dep"
            exit 1
        fi
    done
    echo "[+] Dependencies OK"
}

# Create base image
create_image() {
    local size=$1
    local img_name="nullsec-pi-${EDITION}-${ARCH}.img"
    
    echo "[*] Creating ${size}GB image..."
    dd if=/dev/zero of="${OUTPUT_DIR}/${img_name}" bs=1M count=$((size * 1024)) status=progress
    
    echo "[*] Partitioning..."
    parted -s "${OUTPUT_DIR}/${img_name}" mklabel msdos
    parted -s "${OUTPUT_DIR}/${img_name}" mkpart primary fat32 1MiB 256MiB
    parted -s "${OUTPUT_DIR}/${img_name}" mkpart primary ext4 256MiB 100%
    parted -s "${OUTPUT_DIR}/${img_name}" set 1 boot on
}

# Install base system
install_base() {
    echo "[*] Installing Debian base..."
    local loop=$(sudo losetup -fP --show "${OUTPUT_DIR}/nullsec-pi-${EDITION}-${ARCH}.img")
    
    sudo mkfs.vfat -F 32 "${loop}p1"
    sudo mkfs.ext4 -F "${loop}p2"
    
    mkdir -p /tmp/nullsec-pi-root
    sudo mount "${loop}p2" /tmp/nullsec-pi-root
    sudo mkdir -p /tmp/nullsec-pi-root/boot
    sudo mount "${loop}p1" /tmp/nullsec-pi-root/boot
    
    if [ "$ARCH" = "arm64" ]; then
        sudo qemu-debootstrap --arch=arm64 bookworm /tmp/nullsec-pi-root http://deb.debian.org/debian
    else
        sudo qemu-debootstrap --arch=armhf bookworm /tmp/nullsec-pi-root http://deb.debian.org/debian
    fi
}

# Install NullSec tools
install_tools() {
    echo "[*] Installing NullSec tools..."
    
    cat > /tmp/nullsec-pi-root/tmp/install-tools.sh << 'TOOLS'
#!/bin/bash
apt-get update
apt-get install -y \
    nmap masscan netcat-openbsd \
    aircrack-ng reaver bully \
    wireshark-common tshark \
    hydra medusa john hashcat \
    sqlmap nikto dirb gobuster \
    metasploit-framework \
    python3 python3-pip \
    git curl wget vim \
    wireless-tools wpasupplicant \
    hostapd dnsmasq \
    bluez bluetooth \
    i2c-tools spi-tools \
    can-utils \
    openocd gdb-multiarch \
    gnuradio rtl-sdr hackrf
    
# Install Python tools
pip3 install --break-system-packages \
    impacket scapy pwntools \
    crackmapexec responder \
    bettercap-proxy

# Create nullsec user
useradd -m -s /bin/bash -G sudo,audio,video,dialout,gpio,i2c,spi nullsec
echo "nullsec:nullsec" | chpasswd
TOOLS
    
    sudo chmod +x /tmp/nullsec-pi-root/tmp/install-tools.sh
    sudo chroot /tmp/nullsec-pi-root /tmp/install-tools.sh
}

# Configure stealth mode
configure_stealth() {
    cat > /tmp/nullsec-pi-root/usr/local/bin/nullsec-stealth << 'STEALTH'
#!/bin/bash
# NullSec Stealth Mode Controller

case "$1" in
    enable)
        echo "[*] Enabling stealth mode..."
        # Randomize MAC
        for iface in $(ls /sys/class/net | grep -E '^(eth|wlan)'); do
            ip link set $iface down
            macchanger -r $iface
            ip link set $iface up
        done
        # Disable logging
        systemctl stop rsyslog
        systemctl stop systemd-journald
        # Randomize hostname
        hostnamectl set-hostname "$(cat /dev/urandom | tr -dc 'a-z' | head -c 8)"
        # Clear history
        history -c
        export HISTSIZE=0
        echo "[+] Stealth mode enabled"
        ;;
    disable)
        echo "[*] Disabling stealth mode..."
        systemctl start rsyslog
        systemctl start systemd-journald
        echo "[+] Stealth mode disabled"
        ;;
    *)
        echo "Usage: nullsec-stealth {enable|disable}"
        ;;
esac
STEALTH
    sudo chmod +x /tmp/nullsec-pi-root/usr/local/bin/nullsec-stealth
}

# Main
main() {
    mkdir -p "$OUTPUT_DIR"
    check_deps
    
    case "$EDITION" in
        full) create_image 8 ;;
        lite) create_image 4 ;;
        dropbox) create_image 2 ;;
    esac
    
    install_base
    install_tools
    configure_stealth
    
    echo "[+] Build complete: ${OUTPUT_DIR}/nullsec-pi-${EDITION}-${ARCH}.img"
}

main "$@"
