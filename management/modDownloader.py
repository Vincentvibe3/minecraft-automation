#!/usr/bin/env python3
import requests
import time
import hashlib
import os
import glob
import json
import sys

mc_ver = sys.argv[1]
loader = sys.argv[2]

with open("apikey.txt", "r") as config:
	curseforge_api_key = config.read()

def getInstallList():
	with open("mods.json", "r") as info:
		return info.read()

def download_file(url, filename, headers):
	with requests.get(url, stream=True, headers=headers) as r:
		r.raise_for_status()
		with open(f"./mods/{filename}", "wb") as output:
			for chunk in r.iter_content(chunk_size=8192): 
				output.write(chunk)
	time.sleep(0.2)


def check_checksum(filename, expect, algo):
	if algo == "sha512":
		h = hashlib.sha512()
	elif algo == "sha1":
		h = hashlib.sha1()
	with open(f"./mods/{filename}", 'rb') as fh:
		while True:
			data = fh.read(4096)
			if len(data) == 0:
				break
			else:
				h.update(data)
	return expect == h.hexdigest()

def getModrinth(mod, name):
	base = "https://api.modrinth.com/v2/project/"
	headers = {
		"User-Agent": "vincentvibe3/mod_updater (vincentvibe4@outlook.com)",
	}
	r = requests.get(f'{base}{mod}/version?game_versions=["{mc_ver}"]&loaders=["{loader}"]', headers=headers)
	time.sleep(0.2)
	data = r.json()
	if data:
		mod_version = data[0]["version_number"]
		mod_files = data[0]["files"]
		for file in mod_files:
			extension = file["filename"].split(".")[-1]
			filename = f"{mc_ver}-{mod_version}-{name}.{extension}"
			if os.path.isfile(f"./mods/{filename}"):
				print(f"{mod} already up to date. Nothing to do")
				continue
			else:
				for old_file in glob.glob(f"./mods/*-{name}.*"):
					os.remove(old_file)
				download_file(file["url"], filename, headers)
				if not check_checksum(filename, file["hashes"]["sha512"], "sha512"):
					print(f"Checkum failed for {name}")
					os.remove(f"./mods/{filename}")
				else:
					print(f"{name} installed")
	else:
		print("No version found")

def getCurseforge(mod, name):
	headers = {
		'Accept': 'application/json',
		'x-api-key': curseforge_api_key
	}
	if loader == "fabric":
		loader_enum=4
	elif loader == "quilt":
		loader_enum=5
	elif loader == "forge":
		loader_enum=1
	else:
		loader_enum=0
	url = f"https://api.curseforge.com/v1/mods/{mod}/files?gameVersion={mc_ver}&modLoaderType={loader_enum}"
	r = requests.get(url, headers = headers)
	time.sleep(0.2)
	data = r.json()["data"]
	if data:
		for hash_obj in data[0]["hashes"]:
			hash_value = hash_obj["value"]
			if hash_obj["algo"] == 1:
				break
		download_url = data[0]["downloadUrl"]
		extension = data[0]["fileName"].split(".")[-1]
		filename = f"{mc_ver}-{name}.{extension}"
		for old_file in glob.glob(f"./mods/*-{name}.*"):
			os.remove(old_file)
		download_file(download_url, filename, headers)
		if not check_checksum(filename, hash_value, "sha1"):
			print(f"Checkum failed for {name}")
			os.remove(f"./mods/{filename}")
		else:
			print(f"{name} installed")
	else:
		print("No version found")


mods = json.loads(getInstallList())
if not os.path.exists("mods"):
    os.makedirs("mods")
for mod in mods:
	print(f"Getting {mod['name']}")
	if mod["source"] == "curseforge":
		getCurseforge(mod["id"], mod["name"])
	elif mod["source"] == "modrinth":
		getModrinth(mod["id"], mod["name"])

	