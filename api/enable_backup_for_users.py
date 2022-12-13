#!/usr/bin/env python3
import sys
import requests
import logging
import csv

API_ROOT = "http://<server ip or domain>/api/v1"
API_KEY = "api key"
DOMAIN = "yourdomain.com"
# The column in which the email address is located in the CSV file
EMAIL_COL_IN_CSV = 1
DEBUG = False

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

if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit('Usage: %s <users.csv>' % sys.argv[0])

    if DEBUG:
        logging.basicConfig()
        logging.getLogger().setLevel(logging.DEBUG)
        req_log = logging.getLogger('requests.packages.urllib3')
        req_log.setLevel(logging.DEBUG)
        req_log.propagate = True

    # parse user emails from csv
    user_emails = []
    with open(sys.argv[1], 'r') as csv_file:
        reader = csv.reader(csv_file)

        for row in reader:
            user_emails.append(row[EMAIL_COL_IN_CSV-1])

    # find user id by email
    users = APIRequest("get", "/domains/" + DOMAIN + "/users")
    users = filter(lambda x: x["PrimaryEmail"] in user_emails, users)
    user_ids = [x["Id"] for x in users]

    print("enable backup for", user_emails)
    resp = APIRequest("post",
            "/domains/" + DOMAIN + "/users/batch-update-backup-status",
            data={"EnabledUserIds":user_ids})
    print("API response:", resp)
