#!/usr/bin/env luajit

--lthostname.lua
package.path = "../?.lua"
local procfs = require("lj2procfs.procfs")


local newname = arg[1] or "new-hostname"

print("Hostname GET: ", procfs.sys.kernel.hostname);

print("Hostname SET ('"..newname.."'): ");
procfs.sys.kernel.hostname = newname;

print("Hostname GET: ", procfs.sys.kernel.hostname);