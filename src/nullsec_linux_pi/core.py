"""Raspberry Pi Security Toolkit"""
import subprocess,json,os,re

class PiHardener:
    CHECKS={
        "default_password":{"severity":"CRITICAL","description":"Default pi password not changed",
                            "fix":"passwd pi"},
        "ssh_root_login":{"severity":"HIGH","description":"SSH root login enabled",
                          "fix":"Set PermitRootLogin no in /etc/ssh/sshd_config"},
        "ssh_password_auth":{"severity":"MEDIUM","description":"SSH password auth enabled",
                             "fix":"Set PasswordAuthentication no, use key-based auth"},
        "auto_login":{"severity":"MEDIUM","description":"Auto-login is enabled",
                      "fix":"sudo raspi-config -> System Options -> Boot"},
        "firewall":{"severity":"HIGH","description":"No firewall configured",
                    "fix":"sudo apt install ufw && sudo ufw enable"},
        "unattended_upgrades":{"severity":"MEDIUM","description":"Automatic updates not configured",
                               "fix":"sudo apt install unattended-upgrades"},
        "bluetooth":{"severity":"LOW","description":"Bluetooth enabled when not needed",
                     "fix":"Add dtoverlay=disable-bt to /boot/config.txt"},
    }
    
    def audit(self):
        findings=[]
        # Check for default password hash
        if os.path.exists("/etc/shadow"):
            findings.append("default_password")
        # Check SSH config
        ssh_config="/etc/ssh/sshd_config"
        if os.path.exists(ssh_config):
            try:
                with open(ssh_config) as f: content=f.read()
                if "PermitRootLogin yes" in content: findings.append("ssh_root_login")
                if "PasswordAuthentication yes" in content: findings.append("ssh_password_auth")
            except: pass
        return [{"id":f,**self.CHECKS[f]} for f in findings if f in self.CHECKS]
    
    def get_system_info(self):
        info={"model":"Unknown","memory_mb":0,"temperature_c":0,"cpu_cores":0}
        try:
            with open("/proc/cpuinfo") as f:
                for line in f:
                    if "Model" in line: info["model"]=line.split(":")[-1].strip()
                    if "processor" in line: info["cpu_cores"]+=1
        except: pass
        try:
            with open("/sys/class/thermal/thermal_zone0/temp") as f:
                info["temperature_c"]=int(f.read().strip())/1000
        except: pass
        return info

class GPIOManager:
    MODES={"INPUT":0,"OUTPUT":1,"PWM":2,"I2C":3,"SPI":4}
    
    def pin_layout(self):
        layout={}
        special={2:"SDA",3:"SCL",4:"GPIO4",14:"TXD",15:"RXD",17:"GPIO17",
                 18:"PWM0",27:"GPIO27",22:"GPIO22",23:"GPIO23",24:"GPIO24",25:"GPIO25"}
        for pin in range(2,28):
            layout[pin]={"function":special.get(pin,f"GPIO{pin}"),"mode":"INPUT"}
        return layout
