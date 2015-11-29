--test_iterate_directory.lua
package.path = "../?.lua;"..package.path;

local fs = require("lj2procfs.fs-util")
local libc = require("lj2procfs.libc")
local fun = require("lj2procfs.fun")



local function printFiles(path)
	for _, file in fs.files_in_directory(path) do
		print(file)
	end
end

local function printEntries(path)
	for _, entry in fs.entries_in_directory(path) do
		--print(entry)
		print(entry.Name, libc.DT_DIR == entry.Kind)
	end
end

local function printEntry(entry)
	print(entry.Name)
end

local function printProcs()
	local function isProcess(entry)
		local num = tonumber(entry.Name)
		return entry.Kind == libc.DT_DIR and num
	end

	fun.each(printEntry, fun.filter(isProcess, fs.entries_in_directory("/proc")))
end

local path = arg[1] or "/proc"

--printEntries(path)
--printFiles(path)
printProcs();
