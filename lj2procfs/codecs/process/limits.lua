--[[
	Limits associated with each of the proc's resources
--]]
local function limits(path)
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

return {
	decoder = limits;
}