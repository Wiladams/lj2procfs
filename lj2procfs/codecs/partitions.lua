local function decoder(path)
	path = path or "/proc/partitions"

	local tbl = {}

	local pattern = "%s*(%d+)%s+(%d+)%s+(%d+)%s+(%g+)"
	local linesToSkip = 2;
	for str in io.lines(path) do
		if linesToSkip > 0 then
			linesToSkip = linesToSkip - 1;
		else
			local major, minor, blocks, name = str:match(pattern)
			if name then
				tbl[name] = {
					name = name, 
					major = tonumber(major), 
					minor = tonumber(minor), 
					blocks = tonumber(blocks)
				}
			end
		end
	end

	return tbl
end

return {
	decoder = decoder;
}