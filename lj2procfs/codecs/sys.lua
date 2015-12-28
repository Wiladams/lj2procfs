--ProcessEntry.lua
local libc = require("lj2procfs.libc")
local fs = require("lj2procfs.fs-util")


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
	__pairs = function(tbl)
  		local function gen(tbl, k)
    		local v
      		k, v = next(tbl, k)
    		return k, v
  		end

  		return gen, tbl, nil
	end,

	__index = function(self, key)
		local path = self.Path..'/'..key;

		if fs.isDirectory(path) then		
			return SysEntry(path)
		end

		return get_value(path)
	end,

	__newindex = function(self, key, value)
		local path = self.Path..'/'..key;
		return set_value(value, path)
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

local function sys_decoder(path)
	--print("sys_decoder: ", path)
	return SysEntry:new(path)
end

local function sys_encoder(path)
	print("sys_encoder: ", path)
	return SysEntry:new(path)
end

return {
	decoder = sys_decoder;
	encoder = sys_encoder;
	sysfs = SysEntry;
}

