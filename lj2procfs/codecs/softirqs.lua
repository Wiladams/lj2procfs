--netstat.lua
local labelpatt = "(%g+):(.*)"
local columnNamepatt = "(%g+)"
local columnValuepatt = "(%d+)"

local function getHeaderList(str)
	local tbl = {}
	for columnName in str:gmatch(columnNamepatt) do
		table.insert(tbl, columnName)
	end

	return tbl;
end

local function getValueList(str)
	local label, remainder = str:match(labelpatt)
	local tbl = {}
	for columnValue in remainder:gmatch(columnValuepatt) do
		table.insert(tbl, tonumber(columnValue))
	end

	return label, tbl;
end

local function softirqs(path)
	path = path or "/proc/softirqs"
	local tbl = {}
	local str = nil;

	local f = io.open(path)
	if not f then return nil; end

	-- read column headings
	local firstLine = f:read();
	local columnNames = getHeaderList(firstLine)

	while(true) do
		-- each entry is a combination of two lines
		-- the first line is the header line
		-- the second is the data
		local dataLine = f:read()
		if not dataLine then break end

		local label, columnValues = getValueList(dataLine)

		local rowTbl = {}
		for idx, name in ipairs(columnNames) do
			rowTbl[name] = columnValues[idx];
		end
		tbl[label] = rowTbl;
	end

	return tbl;
end

return {
	decoder = softirqs;

}