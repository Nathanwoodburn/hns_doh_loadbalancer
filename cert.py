#!/usr/bin/env python3
import json
import os
import requests
import sys
import time

AUTH = ""
# Check if token file exists
if os.path.isfile("token"):
    print("ERROR: Token file not found")

# Read token from file
with open("token", "r") as fh:
    AUTH = fh.read().strip()

# Check if token is empty
if len(AUTH) == 0:
    print("ERROR: Token is empty")
    exit(1)





# URL to acme-dns instance
ACMEDNS_URL = "https://nathan.woodburn.au/hnsdoh-acme"
# Path for acme-dns credential storage
STORAGE_PATH = "/etc/letsencrypt/acmedns.json"
# Whitelist for address ranges to allow the updates from
# Example: ALLOW_FROM = ["192.168.10.0/24", "::1/128"]
ALLOW_FROM = []
# Force re-registration. Overwrites the already existing acme-dns accounts.
FORCE_REGISTER = False

DOMAIN = os.environ["CERTBOT_DOMAIN"]
if DOMAIN.startswith("*."):
    DOMAIN = DOMAIN[2:]
VALIDATION_DOMAIN = "_acme-challenge."+DOMAIN
VALIDATION_TOKEN = os.environ["CERTBOT_VALIDATION"]


class AcmeDnsClient(object):
    """
    Handles the communication with ACME-DNS API
    """

    def __init__(self, acmedns_url):
        self.acmedns_url = acmedns_url

    def update_txt_record(self, txt):
        """Updates the TXT challenge record to ACME-DNS subdomain."""
        update = {"txt": txt, "auth": AUTH}
        headers = {"Content-Type": "application/json"}
        res = requests.post(self.acmedns_url,
                            headers=headers,
                            data=json.dumps(update))
        if res.status_code == 200:
            # Successful update
            return
        else:
            msg = ("Encountered an error while trying to update TXT record in "
                   "acme-dns. \n"
                   "------- Request headers:\n{}\n"
                   "------- Request body:\n{}\n"
                   "------- Response HTTP status: {}\n"
                   "------- Response body: {}")
            s_headers = json.dumps(headers, indent=2, sort_keys=True)
            s_update = json.dumps(update, indent=2, sort_keys=True)
            s_body = json.dumps(res.json(), indent=2, sort_keys=True)
            print(msg.format(s_headers, s_update, res.status_code, s_body))
            sys.exit(1)

class Storage(object):
    def __init__(self, storagepath):
        self.storagepath = storagepath
        self._data = self.load()

    def load(self):
        """Reads the storage content from the disk to a dict structure"""
        data = dict()
        filedata = ""
        try:
            with open(self.storagepath, 'r') as fh:
                filedata = fh.read()
        except IOError as e:
            if os.path.isfile(self.storagepath):
                # Only error out if file exists, but cannot be read
                print("ERROR: Storage file exists but cannot be read")
                sys.exit(1)
        try:
            data = json.loads(filedata)
        except ValueError:
            if len(filedata) > 0:
                # Storage file is corrupted
                print("ERROR: Storage JSON is corrupted")
                sys.exit(1)
        return data

    def save(self):
        """Saves the storage content to disk"""
        serialized = json.dumps(self._data)
        try:
            with os.fdopen(os.open(self.storagepath,
                                   os.O_WRONLY | os.O_CREAT, 0o600), 'w') as fh:
                fh.truncate()
                fh.write(serialized)
        except IOError as e:
            print("ERROR: Could not write storage file.")
            sys.exit(1)

    def put(self, key, value):
        """Puts the configuration value to storage and sanitize it"""
        # If wildcard domain, remove the wildcard part as this will use the
        # same validation record name as the base domain
        if key.startswith("*."):
            key = key[2:]
        self._data[key] = value

    def fetch(self, key):
        """Gets configuration value from storage"""
        try:
            return self._data[key]
        except KeyError:
            return None

if __name__ == "__main__":
    # Init
    client = AcmeDnsClient(ACMEDNS_URL)
    storage = Storage(STORAGE_PATH)

    # Update the TXT record in acme-dns instance
    client.update_txt_record(VALIDATION_TOKEN)
    # Wait for the DNS to propagate for 60 seconds
    time.sleep(60)