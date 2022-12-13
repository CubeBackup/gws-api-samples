local http = require("http_client")
local client = http.client()

-- GET
local request = http.request("GET", "http://hostname.com")
local result, err = client:do_request(request)
if err then
    error(err)
end
if not (result.code == 200) then
    error("code")
end
if not (result.body == "xxx.xxx.xxx.xxx") then
    error("body")
end

-- auth basic
local request = http.request("GET", "http://hostname.com")
request:set_basic_auth("admin", "123456")

-- headers
local client = http.client()
local request = http.request("POST", "http://hostname.com/api.json", "{}")
request:header_set("Content-Type", "application/json")

-- with proxy
local client = http.client({ proxy = "http(s)://login:password@hostname.com" })
local request = http.request("POST", "http://hostname.com/api.json", "{}")

-- ignore ssl
local client = http.client({ insecure_ssl = true })
local request = http.request("POST", "http://hostname.com/api.json", "{}")

-- set headers for all request
local client = http.client({ headers = { key = "value" } })

-- set basic auth for all request
local client = http.client({ basic_auth_user = "admin", basic_auth_password = "123456" })
