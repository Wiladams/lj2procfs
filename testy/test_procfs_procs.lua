--test_procfs_procids.lua
package.path = "../?.lua;"..package.path;

local procfs = require("lj2procfs.procfs")
local fun = require("lj2procfs.fun")

local function printFile(entry)
	print(string.format("\t\t\t'%s',", entry))
end

local function printDirectory(entry)
	print(string.format("\t\t\t'%s',", entry.Name))
end

local function printProcessEntries()
for _, procEntry in procfs.processes() do
	print(string.format("\t[%d] = {", procEntry.Id))

	print("\tdirectories = {")
	fun.each(printDirectory, procEntry:directories())
	print("\t},")

	print("\t\tfiles = {")
	fun.each(printFile, procEntry:files())
	print("\t\t},")

	print(string.format("\t},"))
end
end

print(string.format("return {"))
printProcessEntries();
print(string.format("}"))