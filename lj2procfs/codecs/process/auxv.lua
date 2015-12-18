-- auxv_iter.lua

-- An iterator over the auxv values of a process
-- Assuming 'libc' is already somewhere on the path
-- References
--	ld-linux.so
--  getauxval
--  procfs


local ffi = require("ffi")
local libc = require("lj2procfs.libc")

-- This table maps the constant values for the various
-- AT_* types to their symbolic names.  This table is used
-- to both generate cdefs, as well as hand back symbolic names
-- for the keys.
local auxtbl = {
	[0] =  "AT_NULL";
	[1] =  "AT_IGNORE";
	[2] = "AT_EXECFD";
	[3] = "AT_PHDR";
	[4] = "AT_PHENT";
	[5] = "AT_PHNUM";
	[6] = "AT_PAGESZ";
	[7] = "AT_BASE";
	[8] = "AT_FLAGS";
	[9] = "AT_ENTRY";
	[10] = "AT_NOTELF";
	[11] = "AT_UID";
	[12] = "AT_EUID";
	[13] = "AT_GID";
	[14] = "AT_EGID";
	[17] = "AT_CLKTCK";
	[15] = "AT_PLATFORM";
	[16] = "AT_HWCAP";
	[18] = "AT_FPUCW";
	[19] = "AT_DCACHEBSIZE";
	[20] = "AT_ICACHEBSIZE";
	[21] = "AT_UCACHEBSIZE";
	[22] = "AT_IGNOREPPC";
	[23] = "AT_SECURE";
	[24] = "AT_BASE_PLATFORM";
	[25] = "AT_RANDOM";
	[26] = "AT_HWCAP2";
	[31] = "AT_EXECFN";
	[32] = "AT_SYSINFO";
	[33] = "AT_SYSINFO_EHDR";
	[34] = "AT_L1I_CACHESHAPE";
	[35] = "AT_L1D_CACHESHAPE";
	[36] = "AT_L2_CACHESHAPE";
}

local auxsym = {}
for k,v in pairs(auxtbl) do		
	auxsym[v] = k;
end


-- Given a auxv key(type), and the value returned from reading
-- the file, turn the value into a lua specific type.
-- string pointers --> string
-- int values -> number
-- pointer values -> intptr_t
local function strlen(str)
	local idx = 0;
	while true do
		if str[idx] == 0 then
			break
		end
		idx = idx + 1;
	end

	return idx;
end

local function auxvaluefortype(atype, value)

	-- The only time this is going to work and return a string
	-- value is when you are getting the auxv of 'self'
--[[
	if atype == auxsym.AT_EXECFN or atype == auxsym.AT_PLATFORM then
		local charptr = ffi.cast("char *", value)
		local str = ffi.string(charptr)

		return str;
	end
--]]

	if atype == auxsym.AT_UID or atype == auxsym.AT_EUID or
		atype == auxsym.AT_GID or atype == auxsym.AT_EGID or 
		atype == auxsym.AT_FLAGS or atype == auxsym.AT_PAGESZ or
		atype == auxsym.AT_HWCAP or atype == auxsym.AT_CLKTCK or 
		atype == auxsym.AT_PHENT or atype == auxsym.AT_PHNUM then

		return tonumber(value)
	end

	if atype == auxsym.AT_SECURE then
		if value == 0 then 
			return false
		else
			return true;
		end
	end


	return ffi.cast("intptr_t", value);
end

-- iterate over the auxv values at the specified path
-- if no path is specified, use '/proc/self/auxv' to get
-- the values for the currently running program
local function auxv_iter(path)
	local fd = libc.open(path, libc.O_RDONLY);

	local params = {
		fd = fd;
		keybuff = ffi.new("intptr_t[1]");
		valuebuff = ffi.new("intptr_t[1]");
		buffsize = ffi.sizeof(ffi.typeof("intptr_t"));
	}


	local function gen_value(param, state)
		local res1 = libc.read(param.fd, param.keybuff, param.buffsize)
		local res2 = libc.read(param.fd, param.valuebuff, param.buffsize)
		local key = param.keybuff[0];
		local value = param.valuebuff[0];

		if key == 0 then
			libc.close(param.fd);
			return nil;
		end

		local atype = tonumber(key)
		local avalue = auxvaluefortype(atype, value)
		--print("gen_value: ", atype, avalue)

		return state, atype, avalue
	end

	return gen_value, params, 0

end

local function auxv(path)
	local tbl = {}
	for _, atype, value in auxv_iter(path) do
		local fieldkey = auxtbl[atype]
		local fieldvalue = value;

		--print(fieldkey, fieldvalue)
		tbl[fieldkey] = fieldvalue;
	end

	return tbl;
end

return {
	decoder = auxv;
}