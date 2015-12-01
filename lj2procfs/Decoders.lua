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
Decoders.consoles = getRawFile
Decoders.crypto = getRawFile
Decoders.devices = getRawFile
Decoders.diskstats = getRawFile
Decoders.dma = getRawFile
Decoders.execdomains = getRawFile
Decoders.fb = getRawFile
Decoders.filesystems= getRawFile
Decoders.iomem = getRawFile
Decoders.ioports = getRawFile
Decoders.interrupts = getRawFile
Decoders.loginuid = getRawFile
Decoders.stat = getRawFile




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

function Decoders.kallsyms(path)
	path = path or "/proc/kallsyms"

	local tbl = {}
	--local pattern = "(%d+)%s+(%g+)$s+(%g+)"
	local pattern = "(%x+)%s+(%g+)%s+(%g+)"

	for str in io.lines(path)  do
		local loc, kind, name = str:match(pattern)
		if name then
			tbl[name] = {kind = kind, location = loc}
		end
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

function Decoders.meminfo(path)
	path = path or "/proc/meminfo"
	local tbl = {}
	--local pattern = "(%g+):%s+(%d+)%s+(%g+)"
	local pattern = "(%g+):%s+(%d+)%s+(%g+)"

	for str in io.lines(path) do
		local name, size, units = str:match(pattern)
		print(name, size, units)
		if name then
			tbl[name] = tonumber(size);
		end
	end

	return tbl
end


function Decoders.mounts(path)
	local tbl = {}
	for str in io.lines(path) do
		table.insert(tbl, str)
	end

	return tbl
end


function Decoders.partitions(path)
	path = path or "/proc/partitions"

	local tbl = {}

	local pattern = "%s*(%d+)%s+(%d+)%s+(%d+)%s+(%g+)"
	local linesToSkip = 2;
	for str in io.lines(path) do
		if linesToSkip > 0 then
			linesToSkip = linesToSkip - 1;
		else
			local major, minor, blocks, name = str:match(pattern)
			if name then
				tbl[name] = {major = tonumber(major), minor = tonumber(minor), blocks = tonumber(blocks)}
			end
		end
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

--[[
	seconds idle 

	The first value is the number of seconds the system has been up.
	The second number is the accumulated number of seconds all processors
	have spent idle.  The second number can be greater than the first
	in a multi-processor system.
--]]
function Decoders.uptime(path)
	path = path or "/proc/uptime"
	-- open the file
	-- return full contents as a string
	local f = io.open(path)
	local str = f:read("*a")
	f:close()

	local seconds, idle = str:match("(%d*%.?%d+)%s+(%d*%.?%d+)")
	return {
		seconds = tonumber(seconds);
		idle = tonumber(idle);
	}

end

function Decoders.version(path)
	path = path or "/proc/version"
	return getRawFile(path)
end

function Decoders.version_signature(path)
	path = path or "/proc/version_signature"
	return getRawFile(path)
end

function Decoders.vmstat(path)
	local path = path or "/proc/vmstat"

	local tbl = {}
	local pattern = "(%g+)%s+(%d+)"

	for str in io.lines(path) do
		local key, value = str:match(pattern)
		if key then
			tbl[key] = tonumber(value)
		end
	end

	return tbl;
end

return Decoders
