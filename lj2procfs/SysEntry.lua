--ProcessEntry.lua
local libc = require("lj2procfs.libc")
local fs = require("lj2procfs.fs-util")
local fun = require("lj2procfs.fun")
local Decoders = require("lj2procfs.Decoders")


local function get_value(path)
	--print("get_value: ", path)
	local f = io.open(path)
	if not f then
		return nil;
	end

	local str = f:read("*a")
	f:close()

	local vpatt = "(.*)$"
	local vstr = str:match(vpatt)

	return vstr;
end

local function set_value(value, path)
	local f, err = io.open(path, "w")

	if not f == nil then
		return false, err
	end

	f:write(value)
	f:close()
	
	return true;
end


local SysEntry = {}
setmetatable(SysEntry, {
	__call = function(self, path)
		return SysEntry:new(path);
	end,
})


local SysEntry_mt = {
	__index = function(self, key)
		local path = self.Path..'/'..key;

		if fs.isDirectory(path) then		
			return SysEntry(path)
		end

		return get_value(path)
	end,
}

function SysEntry.init(self, path)
	local obj = {
		Path = path
	}

	setmetatable(obj, SysEntry_mt);
	return obj;
end

function SysEntry.new(self, path)
	path = path or "/proc/sys"
	return self:init(path)
end

return SysEntry
