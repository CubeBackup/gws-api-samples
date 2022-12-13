#!/usr/bin/env python3
import sys
import requests
import logging
import json
import time

DEBUG = False

API_ROOT = "http://<server ip or domain>/api/v1"
API_KEY = "a603fa9d501....4b59e594e8e92a"

# CubeBackup license code
LICENSE_CODE = "FC3ED7WZ-XXXXXX-XXXXXX-33E863RM"

# Google Workspace Domain
DOMAIN_NAME = "your-workspace-domain.com"
DOMAIN_ADMIN = "admin@your-workspace-domain.com"

# https://v4beta.cubebackup.com/docs/user_guide/initial_config_linux/#step-3-create-google-service-account
SERVICE_ACCOUNT = "/Users/spider/jwt.json"

# https://v4beta.cubebackup.com/docs/tutorials/cubebackup-api-reference/#the-storage-object
STORAGE_CONFIG = {
    "EncryptEnabled": True,
    "Type": "S3",
    "IndexPath": "/cubebackup_index_s3",
    "S3Bucket": "xxxxx-cubebackup",
    "S3Region": "us-west-1",
    "S3AccessKeyId": "AKIAYF.....53RPHW",
    "S3SecretAccessKey": "eKx+Yvb8T.....rCdi2O0J5d7fn4pP1",
    "S3CoolStorageClass": "GLACIER_IR",
}

# CubeBackup web console admin account
CUBE_ADMIN_NAME = "cube admin"
CUBE_ADMIN_EMAIL = "admin@xxxxx.com"
CUBE_ADMIN_PASSWORD = "xxxxxxxxxx"

def APIRequest(method, path, data=None):
    headers = {"Authorization":API_KEY}
    resp = requests.request(method,
            url=API_ROOT + path,
            json=data,
            headers=headers)
    if resp.status_code == 200:
        return resp.json()
    else:
        raise Exception(resp.text)

def setup_cubebackup():
    print("Check if CubeBackup has completed initial configuration")
    status = APIRequest("get", "/setup/status")
    if status == "done":
        sys.exit("ERROR:CubeBackup already initialized.")

    print("Setup storage")
    APIRequest("post",
            "/storage/settings",
            data=STORAGE_CONFIG)

    print("Upload a GCP service account")
    with open(SERVICE_ACCOUNT) as fp:
        jwt = json.load(fp)
        APIRequest("post",
                "/google/sat",
                data=jwt)

    print("Create a CubeBackup system administrator")
    APIRequest("post",
            "/setup/complete",
            data={
                "AdminName": CUBE_ADMIN_NAME,
                "AdminEmail": CUBE_ADMIN_EMAIL,
                "Password": CUBE_ADMIN_PASSWORD
            })

    print("sleep 5 seconds before the CubeBackup service restarts after completing the initial setup")
    time.sleep(5)

    if LICENSE_CODE != "":
        print("Activate license")
        APIRequest("post",
            "/license/activate",
            data={
                "Code": LICENSE_CODE
            })

    if DOMAIN_NAME != "":
        print("Add Google Workspace domain")
        APIRequest("post",
            "/domains",
            data={
                "DomainName": DOMAIN_NAME,
                "AdminEmail": DOMAIN_ADMIN
            })

        print("Activate domain")
        APIRequest("patch",
            "/domains/%s" % DOMAIN_NAME,
            data={
                "Status": "active",
            })

if __name__ == "__main__":
    if DEBUG:
        logging.basicConfig()
        logging.getLogger().setLevel(logging.DEBUG)
        req_log = logging.getLogger('requests.packages.urllib3')
        req_log.setLevel(logging.DEBUG)
        req_log.propagate = True

    setup_cubebackup()
