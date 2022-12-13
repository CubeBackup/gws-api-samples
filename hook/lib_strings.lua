local inspect = require("inspect")
local strings = require("strings")

-- strings.split(string, sep)
local result = strings.split("a b c d", " ")
print(inspect(result, {newline="", indent=""}))
-- Output: { "a", "b", "c", "d" }

-- strings.has_prefix(string, prefix)
local result = strings.has_prefix("abcd", "a")
-- Output: true

-- strings.has_suffix(string, suffix)
local result = strings.has_suffix("abcd", "d")
-- Output: true

-- strings.trim(string, cutset)
local result = strings.trim("abcd", "d")
-- Output: abc

-- strings.contains(string, substring)
local result = strings.contains("abcd", "d")
-- Output: true
