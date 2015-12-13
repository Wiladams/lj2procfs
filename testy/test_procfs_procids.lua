--test_procfs_procids.lua
package.path = "../?.lua;"..package.path;

local procfs = require("lj2procfs.procfs")
local fun = require("lj2procfs.fun")


local function processIds()
	return fun.map(function(entry) return tonumber(entry.Name) end, fun.filter(isProcess, fs.entries_in_directory("/proc")))
end


for _, id in processIds() do
	print(id)
end