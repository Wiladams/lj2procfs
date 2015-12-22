#!/usr/bin/env luajit

package.path = "../?.lua"

local procfs = require("lj2procfs.procfs")

print("Host Name: ", procfs.sys.kernel.hostname)

