--netstat.lua
local labelpatt = "(%g+):(.*)"
local columnNamepatt = "(%g+)"
local columnValuepatt = "(%g+)"

local function getHeaderList(str)
	local label, remainder = str:match(labelpatt)
	local tbl = {}
	for columnName in remainder:gmatch(columnNamepatt) do
		table.insert(tbl, columnName)
		--print(columnName)
	end

	return label, tbl;
end

local function getValueList(str)
	local label, remainder = str:match(labelpatt)
	local tbl = {}
	for columnValue in remainder:gmatch(columnValuepatt) do
		table.insert(tbl, tonumber(columnValue))
	end

	return label, tbl;
end

local function netstat(path)
	path = path or "/proc/net/netstat"
	local tbl = {}
	local str = nil;

	local f = io.open(path)
	if not f then return nil; end

	while(true) do
		-- each entry is a combination of two lines
		-- the first line is the header line
		-- the second is the data
		local header = f:read()
		if not header then break end

		local label, columnNames = getHeaderList(header)

		if not header then break end

		local data = f:read()
		local columnLabel, columnValues = getValueList(data)

		local rowTbl = {}
		for idx, name in ipairs(columnNames) do
			rowTbl[name] = columnValues[idx];
		end
		tbl[label] = rowTbl;
	end

	return tbl;
end

return {
	decoder = netstat;

}