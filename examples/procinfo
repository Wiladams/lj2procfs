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

local function USAGE()
	print ([[

USAGE: 
	$ sudo ./procfile [PID] <filename>

where <filename> is the name of a file in the /proc
directory.

Example:
	$ sudo ./procfile cpuinfo
	$ sudo ./procfile 13654 limits
]])

	error() 
end

local filename = nil
local PID = nil

if tonumber(arg[1]) then
	PID = tonumber(arg[1])
	filename = arg[2]
else
	filename = arg[1]
end

if not filename then USAGE() end


print("return {")
if PID then
	putil.printValue(procfs[PID][filename], '    ', tostring(PID).."_"..filename)
else
	putil.printValue(procfs[filename], "    ", filename)
end
print("}")
