#!/usr/bin/env luajit

package.path = "../?.lua"

--[[
	get_sysinfo.lua

	Retrieve stuff from the /proc/sys/* directory
	Specify a path to a file, starting with the part
	after '/sys', 

	$ ./get_sysinfo.lua kernel/panic
	
	This is consistent with the strings you might
	specify for a sysctl.conf file.  You can use 
	either a '/' or '.' as the path separator.
--]]

local procfs = require("lj2procfs.procfs")
local sutil = require("lj2procfs.string-util")

local path = arg[1] or ""
local sep = '/'
if path:find("%.") then
	sep = '.'
end

if not sutil.startswith(path,"sys") then
	path = "sys"..sep..path
end

-- The segments can be separated with either a '.' 
-- or '/'
local segments = sutil.tsplit(path, "[%./]")

local node = procfs;
for i=1,#segments do
	node = node[segments[i]]
end

print(path..': ', node)
