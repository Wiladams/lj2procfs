--Decoders.lua

local fun = require("lj2procfs.fun")
local striter= require("lj2procfs.striter")
local strutil = require("lj2procfs.string-util")

local function getRawFile(path)
	local f = io.open(path)
	local str = f:read("*a")
	f:close()
	
	return str;
end


local Decoders = {}
local function findDecoder(self, key)
	local path = "lj2procfs.codecs."..key;

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


-- Specific to processes

function Decoders.environ(path)
	-- open the file
	-- return full contents as a string
	local f = io.open(path)
	
	if not f then return nil end

	local str = f:read("*a")

	local tbl = {}
	-- The environment variables are separated by a null
	-- terminator, so the outer iterator is over that
	for _, elem in striter.mstrziter(str) do
			-- Each individual environment variable is a
			-- key=value pair, so we split those apart.
			local key, value = strutil.split(elem,"=")
			tbl[key] = value;
			--print("environ: ", key, value)
	end

	return tbl;
end


function Decoders.io(path)
	local tbl = {}
	for str in io.lines(path) do
		-- each of these is ':' delimited
		local key, value = strutil.split(str,":")
		tbl[key] = value;
	end

	return tbl
end


--[[
	Limits associated with each of the proc's resources
--]]
function Decoders.limits(path)
	-- Soft Limit, Hard Limit, Units
	local tbl = {}
	local firstline = true;

	for line in io.lines(path) do
		if firstline then 
			firstline = false;
			-- do nothing
		else
			table.insert(tbl, line)
		end
	end

	return tbl;
end


function Decoders.mounts(path)
	local tbl = {}
	for str in io.lines(path) do
		table.insert(tbl, str)
	end

	return tbl
end


function Decoders.sched(path)
	local tbl = {}
	-- skip first two lines
	local linesToSkip = 2
	for str in io.lines(path) do
		if linesToSkip > 0 then
			linesToSkip = linesToSkip - 1;
		elseif str:find(":") then
			-- each of these is ':' delimited
			local key, value = strutil.split(str,":")
			key = strutil.trim(key)
			value = tonumber(value)
			tbl[key] = value;
		end
	end

	return tbl
end


function Decoders.status(path)
	local tbl = {}
	for str in io.lines(path) do
		-- each of these is ':' delimited
		local key, value = strutil.split(str,":")
		tbl[key] = strutil.trim(value);
	end

	return tbl;
end




return Decoders
