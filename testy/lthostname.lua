#!/usr/bin/env luajit

--lthostname.lua
package.path = "../?.lua"

local hostname = require("lj2procfs.codecs.sys.kernel.hostname")

local newname = arg[1] or "new-hostname"

print("Hostname GET: ", hostname())

print("Hostname SET ('"..newname.."'): ", hostname(newname))

print("Hostname GET: ", hostname())