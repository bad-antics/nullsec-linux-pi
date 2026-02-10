from setuptools import setup,find_packages
setup(name="nullsec-linux-pi",version="2.0.0",author="bad-antics",description="Raspberry Pi Linux security toolkit and hardening",packages=find_packages(where="src"),package_dir={"":"src"},python_requires=">=3.8")
