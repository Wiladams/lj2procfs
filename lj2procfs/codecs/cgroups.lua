local pattern = "(%g+)%s+(%d+)%s+(%d+)%s+(%d+)"
local function decoder(path)
	path = path or "/proc/cgroups"

	local tbl = {}
	-- skip header line
	local linesToSkip = 1
	for str in io.lines(path) do
		if linesToSkip > 0 then
			linesToSkip = linesToSkip - 1;
		else
			local subsysName, hierarchy, numCgroups, enabled = str:match(pattern)
			if subsysName then
				tbl[subsysName] = {
					name = subsysName;
					hierarchy = tonumber(hierarchy);
					numCgroups =  tonumber(numCgroups);
					enabled = tonumber(enabled) == 1;
				}
			end
		end
	end

	return tbl
end

return {
	decoder = decoder;
}