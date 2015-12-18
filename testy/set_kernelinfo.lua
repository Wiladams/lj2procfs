#!/usr/bin/env luajit

package.path = "../?.lua"

--[[
	This little utility sets a /proc/sys/kernel/* value
	You can use it simply by doing:

	$ ./set_kernelinfo.lua key value

	where 'key' is one of the files in the /proc/sys/kernel directory
	and 'value' is a string value appropriate for that particular entry
--]]
local procfs = require("lj2procfs.procfs")

local key = arg[1]
local value = arg[2]
assert(key and value, "MUST specify both key and value")

procfs.sys.kernel[key] = value;


