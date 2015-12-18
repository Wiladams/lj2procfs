#!/usr/bin/env luajit
--test_procfs_procids.lua
package.path = "../?.lua;"..package.path;

local procfs = require("lj2procfs.procfs")
local fun = require("lj2procfs.fun")
local Decoders = require("lj2procfs.Decoders")
local putil = require("lj2procfs.print-util")


local function printProcEntry(procEntry)
	print(string.format("\t[%d] = {", procEntry.Id))

	for _, fileEntry in procEntry:files() do
		local fileValue = procEntry[fileEntry.Name]
		putil.printValue(fileValue, '\t\t', fileEntry.Name)
	end

	print(string.format("\t},"))

	collectgarbage()
end


print(string.format("return {"))
fun.each(printProcEntry, procfs.processes())
print(string.format("}"))