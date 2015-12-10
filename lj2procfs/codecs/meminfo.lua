local function meminfo(path)
	path = path or "/proc/meminfo"
	local tbl = {}
	local pattern = "(%g+):%s+(%d+)%s+(%g+)"

	for str in io.lines(path) do
		local name, size, units = str:match(pattern)
		if name then
			tbl[name] = {
				size = tonumber(size), 
				units = units;
			}
		end
	end

	return tbl
end

return {
	decoder = meminfo;
}