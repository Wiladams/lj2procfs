#!/usr/bin/env luajit

--[[
	An easy substitution for the 'hostname' shell command
--]]

package.path = "../?.lua"
local procfs = require("lj2procfs.procfs")

if arg[1] then
	procfs.sys.kernel.hostname = arg[1];
end

print(procfs.sys.kernel.hostname)
