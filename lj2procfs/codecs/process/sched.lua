local strutil = require("lj2procfs.string-util")

-- Entries look like:
--[[
se.statistics.nr_wakeups_passive             :                    0
se.statistics.nr_wakeups_idle                :                    0
avg_atom                                     :             0.043153
avg_per_cpu                                  :             0.247472
--]]
-- We want to break this out into a hierarchy of tables
-- to make it easier to access

local function addToTbl(tbl, key, value)
	print("addToTbl: key")
	local keyparts = strutil.tsplit(key, '%.')
	if #keyparts == 1 then
		tbl[key] = value;
		return 
	else
		if not tbl[keyparts[1]] then
			tbl[keyparts[1]] = {}
		end
		currentTbl = tbl[keyparts[1]]
		table.remove(keyparts, 1)
		return addToTbl(currentTbl, table.concat(keyparts,'.'), value)
	end
end

local function sched(path)
	local tbl = {}
	local colonpatt = "(%g+)%s*:%s+(.*)"

	-- skip first two lines
	local linesToSkip = 2
	for str in io.lines(path) do
		if linesToSkip > 0 then
			linesToSkip = linesToSkip - 1;
		else
			-- each of these is ':' delimited
			local key, value = str:match(colonpatt)
			if key then
				value = tonumber(value)
				addToTbl(tbl, key, value)
			end
		end
	end

	return tbl
end

return {
	decoder = sched;
}