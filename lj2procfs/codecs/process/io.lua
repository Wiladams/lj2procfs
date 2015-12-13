
local function io_func(path)
	local tbl = {}
	local colonpatt = "(%g+):%s+(.*)"

	for str in io.lines(path) do
		local key, value = str:match(colonpatt)
		tbl[key] = value;
	end

	return tbl
end

return {
	decoder = io_func;
}