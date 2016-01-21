local numpatt = "(%d+)"
local cpupatt = "^cpu(%d+)(.*)"
local allcpupatt = "^cpu%s+(.*)"

local fieldNames = {
	"user",
	"nice",
	"system",
	"idle",
	"iowait",
	"irq",
	"softirq",
	"steal",
	"guest",
	"guest_nice";
}

local function readCpuValues(str)
	local row = {}

	local offset = 1;
	for value in str:gmatch(numpatt) do
		row[fieldNames[offset]] = tonumber(value)
		offset = offset + 1;
	end

	return row;
end

local function stat(path)
	path = path or "/proc/stat"

	-- read only first line to get overall information
	local tbl = {}
	tbl.cpus = {}

	for str in io.lines(path) do
		local allcpurest = str:match(allcpupatt)
		--print("stat.allcpu: ", allcpurest, str)
		if allcpurest then
			tbl["allcpus"] = readCpuValues(allcpurest); 
		else
			local cpuid, rest = str:match(cpupatt)
			if cpuid then
				table.insert(tbl.cpus, readCpuValues(rest))
			end 
		end
	end

	return tbl;
end

return {
	decoder = stat;
}