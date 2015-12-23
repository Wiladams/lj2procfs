#!/usr/bin/env luajit
package.path = "../?.lua;"..package.path;

local fs = require("lj2procfs.fs-util")
local libc = require("lj2procfs.libc")
local fun = require("lj2procfs.fun")
local putil = require("lj2procfs.print-util")


local function printEntries(path)
	print("Entries: ", path)
	for _, entry in fs.entries_in_directory(path) do
		putil.printValue(entry, '  ', entry.Name)
	end
end


local path = arg[1] or "/proc"

printEntries(path)

