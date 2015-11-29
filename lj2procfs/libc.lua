local ffi = require("ffi")

require("lj2procfs.platform")

-- dirent.h
ffi.cdef[[
	typedef off_t off64_t;
	typedef ino_t ino64_t;
]]

ffi.cdef[[
enum {
	DT_UNKNOWN = 0,
	DT_FIFO = 1,
	DT_CHR = 2,
	DT_DIR = 4,
	DT_BLK = 6,
	DT_REG = 8,
	DT_LNK = 10,
	DT_SOCK = 12,
	DT_WHT = 14
};
]]

ffi.cdef[[
typedef struct __dirstream DIR;

struct dirent
{
	ino_t d_ino;
	off_t d_off;
	unsigned short d_reclen;
	unsigned char d_type;
	char d_name[256];
};
]]

ffi.cdef[[
int            closedir(DIR *);
DIR           *opendir(const char *);
struct dirent *readdir(DIR *);
int            readdir_r(DIR *__restrict, struct dirent *__restrict, struct dirent **__restrict);

]]

ffi.cdef[[
char *strchr (const char *, int);
]]



local exports = {}
setmetatable(exports, {
	__index = function(self, key)
		local value = nil;
		local success = false;

--[[
		-- try looking in table of constants
		value = C[key]
		if value then
			rawset(self, key, value)
			return value;
		end
--]]

		-- try looking in the ffi.C namespace, for constants
		-- and enums
		success, value = pcall(function() return ffi.C[key] end)
		--print("looking for constant/enum: ", key, success, value)
		if success then
			rawset(self, key, value);
			return value;
		end

		-- Or maybe it's a type
		success, value = pcall(function() return ffi.typeof(key) end)
		if success then
			rawset(self, key, value);
			return value;
		end

		return nil;
	end,
})

return exports
