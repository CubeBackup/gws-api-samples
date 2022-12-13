local email = require("email")
local log = require("log")
local inspect = require("inspect")

if params == nil then
  params = {
      domain = "mydomain.com",
      hook = "BackupDomainComplete",
      task = {
          CalendarEventsCount = 0,
          CalendarTotalSize = 0,
          CompletedSharedDriveCount = 1,
          CompletedUserCount = 0,
          ContactsCount = 0,
          ContactsTotalSize = 0,
          DriveFileCount = 0,
          DriveTotalSize = 0,
          Duration = 106,
          ErrorCount = 0,
          Id = 775,
          MailCount = 0,
          MailTotalSize = 0,
          SharedDriveCount = 1,
          SitesFileCount = 0,
          SitesTotalSize = 0,
          StartTime = 1667895253,
          Status = "success",
          TotalFileCount = 3,
          TotalFileSize = 2131,
          UserCount = 0
      }
  }
end

local sizeUnits = {"B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"}

function ReadableSize(s)
	local i = 1
	while s > 1024 do
		s = s / 1024
		i = i + 1
    end
	return string.format("%.2f %s", s, sizeUnits[i])
end

log.infof("lua hook params %s", inspect(params))

local recipient = "admin@yourdomain.com"
local subject = "Backup accomplished"
local html = {}
table.insert(html, "Backup for " .. params.domain .. " accomplished")
table.insert(html, "status:" .. params.task.Status)
table.insert(html, "file count:" .. params.task.TotalFileCount)
table.insert(html, "file size:" .. ReadableSize(params.task.TotalFileSize))
table.insert(html, "errors:" .. params.task.ErrorCount)
html = table.concat(html, "<br />")

local err = email.send(recipient, subject, html)

if err then
  log.errorf("send mail failed:%s", err)
else
  log.infof("mail sent to %s.", recipient)
end
