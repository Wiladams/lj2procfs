-- 64-bit specific
local ffi = require("ffi")

require("platform")


ffi.cdef[[
static const int  __SI_MAX_SIZE =    128;
]]


if ffi.abi("64bit") then
ffi.cdef[[
static const int __SI_PAD_SIZE    = ((__SI_MAX_SIZE / sizeof (int)) - 4);
]]
else
ffi.cdef[[
static const int __SI_PAD_SIZE    = ((__SI_MAX_SIZE / sizeof (int)) - 3);
]]
end


--[[
# if defined __x86_64__ && __WORDSIZE == 32
/* si_utime and si_stime must be 4 byte aligned for x32 to match the
   kernel.  We align siginfo_t to 8 bytes so that si_utime and si_stime
   are actually aligned to 8 bytes since their offsets are multiple of
   8 bytes.  */
typedef __clock_t __attribute__ ((__aligned__ (4))) __sigchld_clock_t;
#  define __SI_ALIGNMENT __attribute__ ((__aligned__ (8)))
# else
typedef __clock_t __sigchld_clock_t;
#  define __SI_ALIGNMENT
# endif
--]]

ffi.cdef[[
typedef union sigval {
	int sival_int;
	void *sival_ptr;
} sigval_t;
]]

ffi.cdef[[

typedef __clock_t __sigchld_clock_t;
]]

ffi.cdef[[
typedef struct
  {
    int si_signo;		/* Signal number.  */
    int si_errno;		/* If non-zero, an errno value associated with
				   this signal, as defined in <errno.h>.  */
    int si_code;		/* Signal code.  */

    union
      {
	int _pad[__SI_PAD_SIZE];

	 /* kill().  */
	struct
	  {
	    __pid_t si_pid;	/* Sending process ID.  */
	    __uid_t si_uid;	/* Real user ID of sending process.  */
	  } _kill;

	/* POSIX.1b timers.  */
	struct
	  {
	    int si_tid;		/* Timer ID.  */
	    int si_overrun;	/* Overrun count.  */
	    sigval_t si_sigval;	/* Signal value.  */
	  } _timer;

	/* POSIX.1b signals.  */
	struct
	  {
	    __pid_t si_pid;	/* Sending process ID.  */
	    __uid_t si_uid;	/* Real user ID of sending process.  */
	    sigval_t si_sigval;	/* Signal value.  */
	  } _rt;

	/* SIGCHLD.  */
	struct
	  {
	    __pid_t si_pid;	/* Which child.  */
	    __uid_t si_uid;	/* Real user ID of sending process.  */
	    int si_status;	/* Exit value or signal.  */
	    __sigchld_clock_t si_utime;
	    __sigchld_clock_t si_stime;
	  } _sigchld;

	/* SIGILL, SIGFPE, SIGSEGV, SIGBUS.  */
	struct
	  {
	    void *si_addr;	/* Faulting insn/memory ref.  */
	    short int si_addr_lsb;	/* Valid LSB of the reported address.  */
	  } _sigfault;

	/* SIGPOLL.  */
	struct
	  {
	    long int si_band;	/* Band event for SIGPOLL.  */
	    int si_fd;
	  } _sigpoll;

	/* SIGSYS.  */
	struct
	  {
	    void *_call_addr;	/* Calling user insn.  */
	    int _syscall;	/* Triggering system call number.  */
	    unsigned int _arch; /* AUDIT_ARCH_* of syscall.  */
	  } _sigsys;
      } _sifields;
  } siginfo_t __attribute__ ((__aligned__ (8)));
  ]]
