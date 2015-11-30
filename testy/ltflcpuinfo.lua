#!/usr/bin/env luajit

--ltflcpuinfo
-- Print out the /proc/cpuinfo as an interpreted table
-- The text output is valid lua, so it could be transmitted
-- and reconstituted fairly easily.

-- This is also a demonstration of using procfs index values
-- and retrieving the lua equivalent table for a value

package.path = "../?.lua;"..package.path;

local procfs = require("lj2procfs.procfs")
local putil = require("lj2procfs.print-util")

print("return {")
putil.printValue(procfs.cpuinfo, "    ", "cpuinfo")
print("}")