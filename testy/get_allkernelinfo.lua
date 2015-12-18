#!/usr/bin/env luajit

--lthostname.lua
package.path = "../?.lua"

--[[
	this little utility will iterate all the files in /proc/sys/kernel
	and print out their values.
--]]

local procfs = require("lj2procfs.procfs")
local fsutil = require("lj2procfs.fs-util")

for _, entry in fsutil.files_in_directory("/proc/sys/kernel") do
	print(entry.Name)
	print('    ',procfs.sys.kernel[entry.Name])
end


