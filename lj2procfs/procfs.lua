--procfs.lua
local fs = require("lj2procfs.fs-util")
local libc = require("lj2procfs.libc")
local fun = require("lj2procfs.fun")
local ProcessEntry = require("lj2procfs.ProcessEntry")


local procfs = {}

local function toProcId(entry)
	return tonumber(entry.Name)
end

local function toProcess(entry)
	return ProcessEntry(toProcId(entry))
end

local function isProcess(entry)
	local num = tonumber(entry.Name)
	return entry.Kind == libc.DT_DIR and num
end

function procfs.processIds()
	return fun.map(toProcId, fun.filter(isProcess, fs.entries_in_directory("/proc")))
end

function procfs.processes()
	return fun.map(toProcess, fun.filter(isProcess, fs.entries_in_directory("/proc")))
end

return procfs
