--ProcessEntry.lua
local fs = require("lj2procfs.fs-util")
local libc = require("lj2procfs.libc")
local fun = require("lj2procfs.fun")
local Decoders = require("lj2procfs.Decoders")



local ProcessEntry = {}
setmetatable(ProcessEntry, {
	__call = function(self, ...)
		return self:new(...)
	end,
})


local ProcessEntry_mt = {
	__index = function(self, key)
		if ProcessEntry[key] then
			return ProcessEntry[key]
		end

		-- we are essentially a sub-class of Decoders
		if Decoders[key] then
			local path = self.Path..'/'..key;
			return Decoders["process."..key](path);
		end

		return "NO DECODER AVAILABLE"
	end,
}

function ProcessEntry.init(self, procId)
	local obj = {
		Id = procId;
		Path = string.format("/proc/%d", procId);
	}
	setmetatable(obj, ProcessEntry_mt)

	return obj;
end

function ProcessEntry.new(self, procId)
	return self:init(procId)
end


function ProcessEntry.files(self)
	return fs.files_in_directory(self.Path)
end

local function isDirectory(entry)
	return entry.Kind == libc.DT_DIR and 
		entry.Name ~= '.' and
		entry.Name ~= '..'
end

function ProcessEntry.directories(self)
	return fun.filter(isDirectory, fs.entries_in_directory(self.Path))
end


return ProcessEntry
