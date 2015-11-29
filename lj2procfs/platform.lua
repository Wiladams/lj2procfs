local ffi = require("ffi")

-- These types are platform specific
-- and should be taylored to match
ffi.cdef[[
typedef long time_t;
typedef long suseconds_t;
]]



-- These should be good for all versions of Linux
ffi.cdef[[
typedef unsigned int 	mode_t;
typedef unsigned int 	nlink_t;
typedef int64_t 		off_t;
typedef uint64_t 		ino_t;
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
