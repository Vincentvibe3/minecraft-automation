#!/bin/python3

import requests
import subprocess

def get_mc_ver():
	releases = []
	r = requests.get("https://meta.fabricmc.net/v2/versions/game")
	data = r.json()
	for release in data:
		if release["stable"]:
			releases.append(release["version"])
	return releases

def get_fabric_ver():
	r = requests.get("https://meta.fabricmc.net/v2/versions/loader")
	data = r.json()
	for release in data:
		if release["stable"]:
			return release["version"]

def get_installer_ver():
	r = requests.get("https://meta.fabricmc.net/v2/versions/installer")
	data = r.json()
	for release in data:
		if release["stable"]:
			return release["version"]

print("Getting minecraft releases")
releases = get_mc_ver()
mc_ver = ""
while not mc_ver:
	mc_ver = input("What minecraft version should be built? Enter l to see all versions: ")
	if mc_ver == "l":
		for release in releases:
			print(release)
		mc_ver=""
	elif mc_ver not in releases:
		print("Invalid version")
		continue

print("Getting latest Fabric loader")
fabric_ver = get_fabric_ver()
print("Getting latest Fabric installer")
installer_ver  = get_installer_ver()
print("Select a registry to push to (Leave empty for local)")
registry = input()
if registry:
	registry+="/"
split_ver = mc_ver.split(".")
if int(split_ver[0]) == 1 and int(split_ver[1]) < 17:
	build_command = f"buildah build -t {registry}fabric:{mc_ver} -t {registry}fabric:latest -f Dockerfile-java8 --build-arg mc_version={mc_ver} --build-arg fabric_version={fabric_ver} --build-arg fabric_installer_version={installer_ver}"
else:
	build_command = f"buildah build -t {registry}fabric:{mc_ver} -t {registry}fabric:latest --build-arg mc_version={mc_ver} --build-arg fabric_version={fabric_ver} --build-arg fabric_installer_version={installer_ver}"

print("-"*20)
print("Summary:")
print(f"Minecraft version: {mc_ver}")
print(f"Fabric version: {fabric_ver}")
print(f"Fabric Installer version: {installer_ver}")
print(f"Build Command: {build_command}")
print()
can_start_build = input("Continue? [Y/n] ")
if can_start_build.lower() == "y":
	print()
	print("Starting Build")
	print()
	build_process = subprocess.Popen(build_command, shell=True, stdout=subprocess.PIPE)
	for line in build_process.stdout:
		print(line.decode("utf-8"), end="")
	build_process.wait()
else:
	print("Operation cancelled")