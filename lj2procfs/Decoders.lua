--Decoders.lua

local fun = require("lj2procfs.fun")
local striter= require("lj2procfs.striter")
local strutil = require("lj2procfs.string-util")


local Decoders = {}

local function getRawFile(path)
	local f = io.open(path)
	local str = f:read("*a")
	f:close()
	
	return str;
end

-- some raw files, not decoded
Decoders.fb = getRawFile
Decoders.filesystems= getRawFile
Decoders.stat = getRawFile
Decoders.uptime = getRawFile



-- specific decoders


function Decoders.cmdline(path)
	-- open the file
	-- return full contents as a string
	local f = io.open(path)
	local str = f:read("*a")

	local tbl = {}
	for _, str in striter.mstrziter(str) do
		table.insert(tbl,str)
	end

	return tbl;
end

function Decoders.cpuinfo(path)
	path = path or "/proc/cpuinfo"

	local tbl = {}
	local currentTbl = {}
	for str in io.lines(path) do
		if str == "" then
			table.insert(tbl, currentTbl)
			currentTbl = {}
		else
			-- each of these is ':' delimited
			local key, value = strutil.split(str,":")
			key = strutil.trim(key):gsub(' ','_')


			if value ~= "" then 
				value = strutil.trim(value)
			end

			if key == 'flags' then
				value = strutil.tsplit(value, ' ')
			else
				value = tonumber(value) or value
				if value == "yes" then
					value = true
				end
			end
			currentTbl[key] = value;
		end
	end

	return tbl
end

function Decoders.environ(path)
	-- open the file
	-- return full contents as a string
	local f = io.open(path)
	
	if not f then return nil end

	local str = f:read("*a")

	local tbl = {}
	-- The environment variables are separated by a null
	-- terminator, so the outer iterator is over that
	for _, str in striter.mstrziter(str) do
			-- Each individual environment variable is a
			-- key=value pair, so we split those apart.
			local key, value = strutil.split(str,"=")
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




function Decoders.status(path)
	local tbl = {}
	for str in io.lines(path) do
		-- each of these is ':' delimited
		local key, value = strutil.split(str,":")
		tbl[key] = strutil.trim(value);
	end

	return tbl;
end

function Decoders.uptime(path)
	-- open the file
	-- return full contents as a string
	local f = io.open(path)
	local str = f:read("*a")
	f:close()

	return str;
end

return Decoders
