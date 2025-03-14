from setuptools import setup, find_packages

setup(
    name="arkana-launcher",
    version="1.0.0",
    author="TonNom",
    description="Un launcher pour Dofus sans Ankama Launcher",
    packages=find_packages(),
    install_requires=[
        "configparser",
    ],
    entry_points={
        "console_scripts": [
            "arkana-launcher=app:main",
        ],
    },
)
