local log = require("log")
local inspect = require("inspect")

if params == nil then
  params = {
    domain = "yourdomain.com",
    hook = "BackupDomainComplete",
    task = {
      CalendarEventsCount = 0,
      CalendarTotalSize = 0,
      CompletedSharedDriveCount = 0,
      CompletedUserCount = 1,
      ContactsCount = 0,
      ContactsTotalSize = 0,
      DriveFileCount = 0,
      DriveTotalSize = 0,
      Duration = 17,
      ErrorCount = 0,
      Id = 374,
      MailCount = 0,
      MailTotalSize = 0,
      SharedDriveCount = 0,
      SitesFileCount = 0,
      SitesTotalSize = 0,
      StartTime = 1664324481,
      Status = "success",
      TotalFileCount = 0,
      TotalFileSize = 0,
      UserCount = 1
    }
  }
end

log.infof("lua hook params %s", inspect(params))

local http = require("http_client")
local client = http.client()
local pingURL = "https://hc-ping.com/3d270f92-183c-4a09-8983-ed1879bca971"
if params.task.Status == "failed" then
  pingURL = pingURL .. "/fail"
end
local request = http.request("GET", pingURL)
local result, err = client:do_request(request)
log.infof("ping %s response %s", pingURL, result.body)
