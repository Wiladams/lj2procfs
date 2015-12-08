local strutil = require("lj2procfs.string-util")
local pattern = "(%g+)%s+:%s+(%g+)"

local function decoder(path)
	path = path or "/proc/crypto"

	local tbl = {}
	local currentTbl = {}
	for str in io.lines(path) do
		if str == "" then
			tbl[currentTbl.name] = currentTbl;
			currentTbl = {}
		else
			local key, value = str:match(pattern)
			if tonumber(value) then
				currentTbl[key] = tonumber(value)
			else
				currentTbl[key] = value;
			end
		end
	end

	return tbl
end



return {
	decoder = decoder;
}
