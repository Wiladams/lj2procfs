--test_procfs_procids.lua
package.path = "../?.lua;"..package.path;

local procfs = require("lj2procfs.procfs")
local fun = require("lj2procfs.fun")
local Decoders = require("lj2procfs.Decoders")

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
			printTable(entry.Name, mapped, indent)
		elseif type(mapped) == "string" then
			print(string.format("%s['%s'] = [[%s]],", indent, entry.Name, mapped))
		end
	else
		print(string.format("%s'%s',", indent,entry.Name))
	end
end


local function printProcfsFiles()
	--print(string.format("\t[%d] = {", procEntry.Id))

	fun.each(printFile, procfs.files())

	--print(string.format("\t},"))
end

print(string.format("return {"))
printProcfsFiles();
print(string.format("}"))
