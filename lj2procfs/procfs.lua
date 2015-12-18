--procfs.lua
local fs = require("lj2procfs.fs-util")
local libc = require("lj2procfs.libc")
local fun = require("lj2procfs.fun")
local ProcessEntry = require("lj2procfs.ProcessEntry")
local Decoders = require("lj2procfs.Decoders")
local SysEntry = require("lj2procfs.SysEntry")


-- take a table with a 'Name' field, which 
-- should be a numeric value, and return the 
-- ProcessEntry for it
local function toProcessEntry(entry)
	return ProcessEntry(tonumber(entry.Name))
end


local procfs = {
	sys = SysEntry();
}


setmetatable(procfs, {
	__index = function(self, key)
		-- if key is numeric, then return
		-- a process entry 
		if type(key) == "number" or tonumber(key) then
			return ProcessEntry(tonumber(key))
		end


		-- Finally, assume the key is a path  to one
		-- of the files within the /proc hierarchy
		if Decoders[key] then
			return Decoders[key]("/proc/"..key);
		end

		return "NO DECODER AVAILABLE";
	end,
})


function procfs.processes()
	return fun.map(toProcessEntry, fun.filter(
		function(entry)
			return (entry.Kind == libc.DT_DIR) and tonumber(entry.Name)
		end, 
		fs.entries_in_directory("/proc")))
end


return procfs
