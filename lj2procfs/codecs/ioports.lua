--ioports.lua
local toprangepatt = "^(%x+)-(%x+)%s+:%s+(.*)"		-- ^0000-0cf7 : PCI Bus 0000:00
local subrangepatt = "%s+(%x+)%-(%x+)%s+:%s+(.*)"		-- '  0000-0cf7 : PCI Bus 0000:00'
local leafrangepatt = "    (%x+)-(%x+)%s+:%s+(.*)"		-- '  0000-0cf7 : PCI Bus 0000:00'

local function ioports(path)
	path = path or "/proc/ioports"

	local tbl = {}
	tbl.ranges = {}

	for str in io.lines(path) do
		local lowrange,highrange, desc= str:match(toprangepatt)
		if lowrange then
			print(lowrange, highrange, desc)
			table.insert(tbl.ranges, {low = tonumber(lowrange,16), high = tonumber(highrange,16), description = desc})
		else
			local sublow,subhigh,subdesc= str:match(subrangepatt)
			if sublow then
				table.insert(tbl,{low = tonumber(sublow, 16), high = tonumber(subhigh,16), description = subdesc})
			end
		end
	end

	return tbl;
end

return {
	decoder = ioports;
}