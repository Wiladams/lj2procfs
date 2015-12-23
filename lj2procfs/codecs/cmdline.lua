-- can be used for both /proc/cmdline, and /proc/[pid]/cmdline
local sutil= require("lj2procfs.string-util")

local function decoder(path)
	-- open the file
	-- return full contents as a string
	local f = io.open(path)
	local str = f:read("*a")

	local tbl = {}
	-- can possibly be a string of '\0' delimited values
	for _, str in sutil.mstrziter(str) do
		table.insert(tbl,str)
	end

	return tbl;
end

return {
	decoder = decoder;
}