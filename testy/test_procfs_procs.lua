--test_procfs_procids.lua
package.path = "../?.lua;"..package.path;

local procfs = require("lj2procfs.procfs")
local fun = require("lj2procfs.fun")
local Decoders = require("lj2procfs.Decoders")
local putil = require("lj2procfs.print-util")



local function printTable(name, tbl, indent)
	indent = indent or ""
	--print("TABLE: ", #mapped)
	print(string.format("%s['%s'] = {", indent, name))
	if #tbl > 0 then
		-- it's a list,so use ipairs
		for _, value in ipairs(tbl) do
			print(string.format("%s\t'%s',",indent, value))
		end
	else
		-- assume it's a dictionary, so use pairs
		for key, value in pairs(tbl) do
			print(string.format("%s\t['%s'] = [[%s]],",indent, key, value))
		end
	end

	print(string.format("%s},", indent))
end

local function printFile(entry)
	local mapper = Decoders[entry.Name]
	local indent = '\t\t\t'
	if mapper then
		local mapped = mapper(entry.Path)
		if type(mapped) == "table" then
			putil.printValue(mapped, indent, entry.Name)
			--printTable(entry.Name, mapped, indent)
		elseif type(mapped) == "string" then
			print(string.format("%s['%s'] = [[%s]],", indent, entry.Name, mapped))
		end
	else
		print(string.format("%s'%s',", indent,entry.Name))
	end
end

local function printDirectory(entry)
	print(string.format("\t\t\t'%s',", entry.Name))
end

local function printProcessEntries()
	for _, procEntry in procfs.processes() do
		print(string.format("\t[%d] = {", procEntry.Id))

		print("\t\tdirectories = {")
		fun.each(printDirectory, procEntry:directories())
		print("\t\t},")

		print("\t\tfiles = {")
		fun.each(printFile, procEntry:files())
		print("\t\t},")

		print(string.format("\t},"))
	end
end

print(string.format("return {"))
printProcessEntries();
print(string.format("}"))