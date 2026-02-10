from nullsec_linux_pi.core import PiHardener,GPIOManager
h=PiHardener()
print("Security Checks:")
for name,check in h.CHECKS.items(): print(f"  [{check['severity']}] {name}: {check['description']}")
g=GPIOManager()
print(f"\nGPIO Layout:")
for pin,info in list(g.pin_layout().items())[:10]: print(f"  Pin {pin}: {info['function']}")
