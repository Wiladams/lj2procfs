# lj2procfs
LuaJIT access to Linux /proc file system

On Linux systems, /proc is a source of much useful information, such as the number of processes
running on the machine, mount points, cpu information, threads, memory utilization, io statistics,
and the like.  In classic UNIX fashion, everything is a file, and they are accessed through the 
directory mounted under /proc.

These files are variously readable either by humans or machine processes.  There are numerous 
command line tools that make this information more or less accessible, as long as you know all the
commands, and their attendant flags, quirks, and whatnot.

This binding to the procfs makes accessing various aspects of the file system relatively easy.

At the highest level, gaining access to the information whithin files that are directly in /proc, is
as easy as the following example, which gets at the /proc/cpuinfo file.

```lua
package.path = "../?.lua;"..package.path;

local procfs = require("lj2procfs.procfs")
local putil = require("lj2procfs.print-util")

print("return {")
putil.printValue(procfs.cpuinfo, "    ", "cpuinfo")
print("}")
```

The meat of it is the one call: procfs.cpuinfo

This will return a table, which contains the already parsed information.  Numeric values become lua numbers, the word "yes", becomes a boolean 'true', and everything else becomes a quoted string.  Since you now have a table,
you can easily use that in any way within your lua program.
