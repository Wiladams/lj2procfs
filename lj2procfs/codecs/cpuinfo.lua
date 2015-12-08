local strutil = require("lj2procfs.string-util")

local function decoder(path)
	path = path or "/proc/cpuinfo"

	local tbl = {}
	local currentTbl = {}
	for str in io.lines(path) do
		if str == "" then
			table.insert(tbl, currentTbl)
			currentTbl = {}
		else
			-- each of these is ':' delimited
			local key, value = strutil.split(str,":")
			key = strutil.trim(key):gsub(' ','_')


			if value ~= "" then 
				value = strutil.trim(value)
			end

			if key == 'flags' then
				value = strutil.tsplitbool(value, ' ')
			else
				value = tonumber(value) or value
				if value == "yes" then
					value = true
				end
			end
			currentTbl[key] = value;
		end
	end

	return tbl
end

return {
	decoder = decoder;
}
