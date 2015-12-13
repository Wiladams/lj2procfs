
local function status(path)
	-- each of these is ':' delimited
	local pattern = "(%g+):%s+(.*)"
	local tbl = {}
	

	for str in io.lines(path) do
	print(str)
		local key, value = str:match(pattern)
		if key then
			tbl[key] = value;
		end
	end

	return tbl;
end

return {
	decoder = status;
}