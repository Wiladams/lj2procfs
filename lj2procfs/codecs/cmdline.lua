-- can be used for both /proc/cmdline, and /proc/[pid]/cmdline
local striter= require("lj2procfs.striter")

function decoder(path)
	-- open the file
	-- return full contents as a string
	local f = io.open(path)
	local str = f:read("*a")

	local tbl = {}
	-- can possibly be a string of '\0' delimited values
	for _, str in striter.mstrziter(str) do
		table.insert(tbl,str)
	end

	return tbl;
end

return {
	decoder = decoder;
}