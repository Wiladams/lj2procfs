local ffi = require("ffi")

-- These types are platform specific
-- and should be taylored to match
ffi.cdef[[
typedef long time_t;
typedef long suseconds_t;
]]

if ffi.abi("64bit") then
ffi.cdef[[
typedef int64_t off_t;
typedef int64_t ino_t;
]]
else
ffi.cdef[[
typedef int off_t;
typedef int ino_t;
]]
end

-- These should be good for all versions of Linux
ffi.cdef[[
typedef unsigned int 	mode_t;
typedef unsigned int 	nlink_t;
typedef uint64_t 		dev_t;
typedef long 			blksize_t;
typedef int64_t 		blkcnt_t;
typedef uint64_t 		fsblkcnt_t;
typedef uint64_t 		fsfilcnt_t;

typedef unsigned int 	wint_t;
typedef unsigned long 	wctype_t;

typedef void * 			timer_t;
typedef int 			clockid_t;
typedef long 			clock_t;

struct timeval { time_t tv_sec; suseconds_t tv_usec; };
struct timespec { time_t tv_sec; long tv_nsec; };
]]

ffi.cdef[[
typedef int pid_t;
typedef unsigned int id_t;
typedef unsigned int uid_t;
typedef unsigned int gid_t;
typedef int key_t;
typedef unsigned int useconds_t;
]]

ffi.cdef[[
typedef struct _IO_FILE FILE;
]]


ffi.cdef[[
typedef int32_t		__pid_t;
typedef uint32_t	__uid_t;
typedef long		__clock_t;
typedef int32_t		__clockid_t;
typedef int32_t		__gid_t;
]]



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

-- fcntl.h
ffi.cdef[[
int open(const char *, int, ...);
]]

ffi.cdef[[
static const int	O_ACCMODE	= 00000003;
static const int	O_RDONLY	= 00000000;
static const int	O_WRONLY	= 00000001;
static const int	O_RDWR		= 00000002;
]]

-- unistd.h
ffi.cdef[[
int close(int);
ssize_t read(int, void *, size_t);
ssize_t write(int, const void *, size_t);
]]

ffi.cdef[[
int            closedir(DIR *);
DIR           *opendir(const char *);
struct dirent *readdir(DIR *);
int            readdir_r(DIR *__restrict, struct dirent *__restrict, struct dirent **__restrict);

ssize_t readlink(const char *__restrict, char *__restrict, size_t);

]]

ffi.cdef[[
char *strchr (const char *, int);
]]



local exports = {}
setmetatable(exports, {
	__index = function(self, key)
		local value = nil;
		local success = false;


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
