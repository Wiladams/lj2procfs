--Decoders.lua

local fun = require("lj2procfs.fun")
local strutil = require("lj2procfs.string-util")

local function getRawFile(path)
	local f = io.open(path)
	local str = f:read("*a")
	f:close()
	
	return str;
end

-- Use this table if you want to map from the names that 
-- are relative to the /proc directory, to values sitting
-- directly within the codec directory
--[[
local decoderMap = {
	["%d+/cwd"] = "linkchaser";
	["%d+/exe"] = "linkchaser";
	["%d+/root"] = "linkchaser";
}
--]]

local Decoders = {}
local function findDecoder(self, key)
	-- traverse through the mappings looking for a match
--[[
	for pattern, value in pairs(decoderMap) do
		if key:match(pattern) then
			key = value
			break;
		end
	end
--]]

	local path = "lj2procfs.codecs."..key;
--print("findDecoder(), PATH: ", path)

	-- try to load the intended codec file
	local success, codec = pcall(function() return require(path) end)
	if success and codec.decoder then
		return codec.decoder;
	end

	-- if we didn't find a decoder, use the generic raw file loading
	-- decoder.
	-- Caution: some of those files can be very large!
	return getRawFile;
end
setmetatable(Decoders, {
	__index = findDecoder;

})


return Decoders
