#!/usr/bin/env luajit

package.path = "../?.lua"

--[[
	get_sysinfo.lua

	Retrieve stuff from the /proc/sys/* directory
	Specify a path to a file, starting with the '/sys' part

	$ ./get_sysinfo.lua sys/kernel/panic
	
--]]
local procfs = require("lj2procfs.procfs")
local sutil = require("lj2procfs.string-util")

local path = arg[1] or "sys"

local segments = sutil.tsplit(path, '/')

local node = procfs;
for i=1,#segments do
	node = node[segments[i]]
end

print(path..': ', node)
