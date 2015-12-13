
local function mounts(path)
	local tbl = {}
	for str in io.lines(path) do
		table.insert(tbl, str)
	end

	return tbl
end

return {
	decoder = mounts;
}