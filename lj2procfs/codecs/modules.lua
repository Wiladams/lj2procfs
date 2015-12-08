local strutil = require("lj2procfs.string-util")

local pattern1 = "(%g+) (%d+) (%d+)%s+-%s+(%g+)%s+(%g+)"
local pattern2 = "(%g+) (%d+) (%d+)%s+(%g+),%s+(%g+)%s+(%g+)"

-- For each line, the 'used' field show how many times this
-- module is being used by something else
-- If that 'something else' is itself a module, then the 'by'
-- field indicates the names of those other modules.  Otherwise,
-- it is blank.
local function decoder(path)
	path = path or "/proc/modules"
	
	local tbl = {}

	for str in io.lines(path) do
		-- first try pattern 1, as this will indicate no 'by' field
		local name, size, used, status,  address = str:match(pattern1)
		if name then
			tbl[name] = {
				size = tonumber(size),
				used = tonumber(id),
				status = status,
				address = address,
				by = {},
			}
		else
			-- try pattern 2, which will separate out the 'by' field
			-- into a table
			name, size, id, by, status, address = str:match(pattern2)
			tbl[name] = {
				size = tonumber(size),
				used = tonumber(id),
				by = strutil.tsplitbool(by,','),
				status = status,
				address = address,
			}
		end
	end

	return tbl;
end

return {
	decoder = decoder;
}