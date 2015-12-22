--procfs.lua
local fs = require("lj2procfs.fs-util")
local libc = require("lj2procfs.libc")
local fun = require("lj2procfs.fun")
local ProcessEntry = require("lj2procfs.ProcessEntry")


-- take a table with a 'Name' field, which 
-- should be a numeric value, and return the 
-- ProcessEntry for it
local function toProcessEntry(entry)
	return ProcessEntry(tonumber(entry.Name))
end

local function getRawFile(path)
	local f = io.open(path)
	local str = f:read("*a")
	f:close()
	
	return str;
end

local function findDecoder(key)

	local path = "lj2procfs.codecs."..key;
--print("findDecoder(), PATH: ", path)

	-- try to load the intended codec file
	local success, codec = pcall(function() return require(path) end)
	if success and codec.decoder then
		return codec.decoder;
	end

	return nil;
end

local procfs = {}


setmetatable(procfs, {
	__index = function(self, key)

		-- if key is numeric, then return
		-- a process entry 
		if type(key) == "number" or tonumber(key) then
			return ProcessEntry(tonumber(key))
		end


		-- Finally, assume the key is a path  to one
		-- of the files within the /proc hierarchy
		local path = "/proc/"..key
		--print("procfs.__index: ", key, path)
		local decoder = findDecoder(key)

		if decoder then
			return decoder(path)
		else
			return "NO DECODER AVAILABLE FOR: "..path
--			return getRawFile(path)
		end
	end,
})


function procfs.processes()
	-- map directories with numeric names to ProcessEntry
	return fun.map(toProcessEntry, fun.filter(
		function(entry)
			return (entry.Kind == libc.DT_DIR) and tonumber(entry.Name)
		end, 
		fs.entries_in_directory("/proc")))
end


return procfs