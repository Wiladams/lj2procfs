#!/usr/bin/env luajit
package.path = "../?.lua;"..package.path;

local procfs = require("lj2procfs.procfs")
local fun = require("lj2procfs.fun")

print("Num Procs: ", fun.length(procfs.processes()))
