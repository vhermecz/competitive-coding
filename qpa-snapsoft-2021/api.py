import glob
import requests
import json
import os
import logging
from io import BytesIO
import zipfile

BASE_URL = "https://challenge.snapsoft.hu/"

def debug():
	try:
	    import http.client as http_client
	except ImportError:
	    # Python 2
	    import httplib as http_client
	http_client.HTTPConnection.debuglevel = 1
	logging.basicConfig()
	logging.getLogger().setLevel(logging.DEBUG)
	requests_log = logging.getLogger("requests.packages.urllib3")
	requests_log.setLevel(logging.DEBUG)
	requests_log.propagate = True

# debug()

API_TOKEN = os.environ.get('API_TOKEN')

def start_sub(prob_id, sample_idx = None):
	url = BASE_URL + "api/submissions/start-submission"
	data = {
		"problem": prob_id,
	}
	headers = {
		"X-Api-Token": API_TOKEN,
	}
	if sample_idx is not None:
		data["sample_index"] = sample_idx
	r = requests.post(url, headers=headers, json=data)
	try:
		return r.json()['submission']
	except Exception:
		print(f"ERROR: {r.text}")
		raise


def get_sub_test(sub_id):
	url = BASE_URL + "api/submissions/test"
	data = {
		"submission": sub_id,
	}
	headers = {
		"X-Api-Token": API_TOKEN,
	}
	r = requests.put(url, headers=headers, json=data)
	try:
		return r.json()
	except Exception:
		print(f"ERROR: {r.text}")
		raise

def post_test(test_id, output):
	url = BASE_URL + f"api/submissions/test/{test_id}"
	data = {
		"output": output,
	}
	headers = {
		"X-Api-Token": API_TOKEN,
	}
	r = requests.post(url, headers=headers, json=data)
	try:
		return r.json()
	except Exception:
		print(f"ERROR: {r.text}")
		raise

def generate_zip(files):
    mem_zip = BytesIO()
    with zipfile.ZipFile(mem_zip, mode="w",compression=zipfile.ZIP_DEFLATED) as zf:
        for f in files.items():
            zf.writestr(f[0], f[1])
    return mem_zip.getvalue()

def post_source(prob_id, main_file):
	url = BASE_URL + f"files/api/submissions/code-upload/{prob_id}/{main_file}"
	data = generate_zip({fname: open(fname).read() for fname in glob.glob("*")})
	files = [
		('file', ('solution.zip', data, 'application/zip')),
	]
	headers = {
		"X-Api-Token": API_TOKEN,
	}
	r = requests.post(url, headers=headers, files=files)
	try:
		return r.json()
	except Exception:
		print(f"ERROR: {r.text}")
		raise