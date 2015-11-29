--test_procfs_procids.lua
package.path = "../?.lua;"..package.path;

local procfs = require("lj2procfs.procfs")

for _, id in procfs.processIds() do
	print(id)
end