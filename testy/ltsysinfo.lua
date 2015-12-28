#!/usr/bin/env luajit

package.path = "../?.lua"

--[[
    get_sysinfo.lua

    Retrieve stuff from the /proc/sys/* directory
    Specify a path to a file, starting with the part
    after '/sys', 

    $ ./get_sysinfo.lua kernel/panic
    
    This is consistent with the strings you might
    specify for a sysctl.conf file.  You can use 
    either a '/' or '.' as the path separator.
--]]

local procfs = require("lj2procfs.procfs")
local sutil = require("lj2procfs.string-util")
local sysfs = require("lj2procfs.codecs.sys")
local putil = require("lj2procfs.print-util")


local path = arg[1] or ""
local sep = '/'
if path:find("%.") then
    sep = '.'
end



-- The segments can be separated with either a '.' 
-- or '/'
print("path: ", path)
local segments = sutil.tsplit(path, "[%./]")

local node = sysfs.sysfs("/sys");
for i=1,#segments do
    print(segments[i])
    node = node[segments[i]]
end

print(path..': ')
putil.printValue(node)
