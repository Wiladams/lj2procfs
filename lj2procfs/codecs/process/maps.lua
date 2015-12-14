--maps.lua
-- perms
-- r - read
-- w - write
-- x - execute
-- s - shared
-- p - private

local function maps(path)
	local tbl = {}
	local pattern = "(%x+)-(%x+)%s+(%g+)%s+(%x+)%s+(%d+):(%d+)%s+(%d+)%s+(.*)"

	for str in io.lines(path) do
		local lowaddr, highaddr, perms, offset, major, minor, inode, pathname = str:match(pattern)
		if lowaddr then
			local rowTbl = {
				lowaddr = lowaddr,
				highaddr = highaddr,
				perms = perms, 
				offset = offset, 
				dev_major = tonumber(major),
				dev_minor = tonumber(minor),
				inode = tonumber(inode),
				path = pathname,
			}

			table.insert(tbl, rowTbl)
		end
	end

	return tbl;
end

return {
	decoder = maps;
}