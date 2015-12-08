
local function iomem(path)
	path = path or "/proc/iomem"

	local tbl = {}
	local pattern = "(%x+)-(%x+) : (.*)"
	for str in io.lines(path) do
		local low, high, desc = str:match(pattern)
		if low then
			table.insert(tbl, {low = tonumber(low,16), high = tonumber(high,16), description = desc})
		end
	end

	return tbl;
end

return {
	decoder = iomem;
}