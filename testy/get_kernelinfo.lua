#!/usr/bin/env luajit

package.path = "../?.lua"

local procfs = require("lj2procfs.procfs")

print(arg[1]..': ', procfs.sys.kernel[arg[1]])

