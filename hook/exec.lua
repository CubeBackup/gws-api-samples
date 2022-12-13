local cmd = require("cmd")
local log = require("log")

local command = "df -h"
local timeout = 60 -- seconds
local result, err = cmd.exec(command, timeout)
if err then
  log.errorf("exec failed:%s", err)
else
  log.infof("%s\n status:%d\n stdout:%s\n stderr:%s", command, result.status, result.stdout, result.stderr)
end
