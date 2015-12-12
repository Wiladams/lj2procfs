

local labelpatt = "(%g+):(.*)"
local columnValuepatt = "(%g+)"

local headings = {
	"rx_bytes",
	"rx_packets",
	"rx_errs",
	"rx_drop",
	"rx_fifo",
	"rx_frame",
	"rx_compressed",
	"rx_multicast",

	"tx_bytes",
	"tx_packets",
	"tx_errs",
	"tx_drop",
	"tx_fifo",
	"tx_collisions",
	"tx_carrier",
	"tx_compressed"
}

local function getValueList(str)
	local label, remainder = str:match(labelpatt)
	local tbl = {}
	for columnValue in remainder:gmatch(columnValuepatt) do
		table.insert(tbl, tonumber(columnValue))
	end

	return label, tbl;
end

local function net_dev(path)
	path = path or "/proc/net/dev"

	local tbl = {}
	local linesToSkip = 2
	for str in io.lines(path) do
		local rowTbl = {}
		if linesToSkip > 0 then
			linesToSkip = linesToSkip - 1;
		else
			local label, values = getValueList(str)
			for idx, name in ipairs(headings) do
				rowTbl[name] = values[idx];
			end

			tbl[label] = rowTbl;
		end
	end

	return tbl;
end

return {
	decoder = net_dev;
}