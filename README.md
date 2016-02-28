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

If you wanted to perform a task such as list which processors are associated with which cores,
you could do the following:

```lua
local procfs = require("lj2procfs.procfs")
local fun = require("lj2procfs.fun")


local function printInfo(processor)
	print(string.format("processor: %d, core: %d", processor.processor, processor.core_id))
end

fun.each(printInfo, procfs.cpuinfo)
```

And the output might look something like this

```lua
processor: 0, core: 0
processor: 1, core: 1
processor: 2, core: 2
processor: 3, core: 3
processor: 4, core: 0
processor: 5, core: 1
processor: 6, core: 2
processor: 7, core: 3
```

There are a number of tasks which become fairly easy to perform from within lua script, such as 
counting the number of processes that are currently running in the system.

```lua
#!/usr/bin/env luajit
package.path = "../?.lua;"..package.path;

local procfs = require("lj2procfs.procfs")
local fun = require("lj2procfs.fun")

print("Num Procs: ", fun.length(procfs.processes()))
```

Of course you could already do this by simply running 'ps', or some other command line tool.  The benefit
of having this binding, is that you can easily perform the task without having to shell out to get
simple tasks done.  This makes it far easier to incorporate the information into an automated workflow.

If you wanted to go all out and print all the information about all the processes currently  running
on the machine, you could do the following:

```lua
local procfs = require("lj2procfs.procfs")
local fun = require("lj2procfs.fun")
local putil = require("lj2procfs.print-util")


local function printProcEntry(procEntry)
	print(string.format("\t[%d] = {", procEntry.Id))

	for _, fileEntry in procEntry:files() do
		local fileValue = procEntry[fileEntry.Name]
		putil.printValue(fileValue, '\t\t', fileEntry.Name)
	end

	print(string.format("\t},"))
end


print(string.format("return {"))
fun.each(printProcEntry, procfs.processes())
print(string.format("}"))
```
Which might generate some output, which partially looks like:

```lua
return {
	[1] = {
		['environ'] = {
		    PATH = [[/sbin:/usr/sbin:/bin:/usr/bin]],
		    HOME = [[/]],
		    rootmnt = [[/root]],
		    recovery = '',
		    PWD = [[/]],
		    TERM = [[linux]],
		    BOOT_IMAGE = [[/vmlinuz-3.19.0-26-generic.efi.signed]],
		    init = [[/sbin/init]],
		};
		auxv = [[nil]],
```

Of course, you don't have to generate any output at all.  You could just form
queries whereby you iterate over processes, looking for specific attributes, and 
delivering some action based on seeing those attributes.


Installation
============

There are a couple of ways to install the package into your 
luajit environment.  The first method involves using luarocks.  If
you have luarocks, you can install one of the existing pre-packaged
rocks from well known repositories using the following:

$ luarocks install lj2procfs


Alternatively, if you want to install directly from the repository
you can simply copy the appropriate files into a well known lua
modules directory.  On Linux systems, this might be:

'/usr/local/share/lua/5.1'

While sitting in the l2jprocfs directory, you might do:

$sudo cp -r lj2procfs /usr/local/share/lua/5.1
