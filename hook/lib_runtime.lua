local runtime = require("runtime")
if not(runtime.goos() == "linux") then error("not linux") end
if not(runtime.goarch() == "amd64") then error("not amd64") end
