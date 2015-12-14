--buddyinfo.lua
-- Reference
-- http://andorian.blogspot.com/2014/03/making-sense-of-procbuddyinfo.html
--
local pow = math.pow

local headingpattern = "Node%s+(%d+).*zone%s+(%w+)%s+(.*)"
local chunkpatt = "(%d+)"

local function buddyinfo(path)
	local tbl = {}

	for str in io.lines(path) do
		local numa_node, zone, numbers = str:match(headingpattern)

		if numa_node then
			if not tbl["numa_"..numa_node] then
				tbl["numa_"..numa_node] = {}
			end

			local rowTbl = {}

			local chunknum = 0;
			for chunkval in numbers:gmatch(chunkpatt) do
				--print(chunknum, chunkval)

				table.insert(rowTbl, {order = chunknum, available = tonumber(chunkval)})
				chunknum = chunknum + 1
			end
			tbl["numa_"..numa_node][zone] = rowTbl;
		end
	end

	return tbl;
end

return {
	decoder = buddyinfo;
}