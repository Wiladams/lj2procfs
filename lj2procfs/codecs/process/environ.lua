local striter= require("lj2procfs.striter")

local function environ(path)
	-- open the file
	-- return full contents as a string
	local f = io.open(path)
	
	if not f then return nil end

	local str = f:read("*a")

	local tbl = {}
	local eqpatt = "(%g+)=(.*)"

	-- The environment variables are separated by a null
	-- terminator, so the outer iterator is over that
	for _, elem in striter.mstrziter(str) do
		-- Each individual environment variable is a
		-- key=value pair, so we split those apart.
		local key, value = elem:match(eqpatt);
		tbl[key] = value;
	end

	return tbl;
end

return {
	decoder = environ;
}