#!/usr/bin/env luajit

--[[
	procfile

	This is a general purpose /proc/<file> interpreter.
	Usage:  
		$ sudo ./procfile filename

	Here, 'filname' is any one of the files listed in the 
	/proc directory.

	In the cases where a decoder is implemented in Decoders.lua
	the file will be parsed, and an appropriate value will be
	returned and printed in a lua form appropriate for reparsing.

	When there is no decoder implemented, the value returned is
	"NO DECODER AVAILABLE"

	example:
		$ sudo ./procfile cpuinfo
		$ sudo ./procfile partitions

--]]

package.path = "../?.lua;"..package.path;

local procfs = require("lj2procfs.procfs")
local putil = require("lj2procfs.print-util")

if not arg[1] then
	print ([[

USAGE: 
	$ sudo ./procfile <filename>

where <filename> is the name of a file in the /proc
directory.

Example:
	$ sudo ./pocfile cpuinfo
]])

	return 
end


local filename = arg[1]

print("return {")
putil.printValue(procfs[filename], "    ", filename)
print("}")