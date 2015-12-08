
local function vmstat(path)
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

return {
	decoder = vmstat;
}