#!/usr/bin/env luajit

--lthostname.lua
package.path = "../?.lua"

local procfs = require("lj2procfs.procfs")
local sutil = require("lj2procfs.string-util")

local path = arg[1] or "sys"

local segments = sutil.tsplit(path, '/')

local node = procfs;
for i=1,#segments do
	node = node[segments[i]]
end

print(path..': ', node)
