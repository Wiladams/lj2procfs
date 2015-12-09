local strutil = require("lj2procfs.string-util")

local namepatt = "(%g+):(.*)"
local numberspatt = "[%s*(%d+)]+"
local descpatt = "[%s*(%d+)]+(.*)"

local function numbers(value)
	num, other = string.match(value, numpatt)
	return num;
end

local function interrupts(path)
	path = path or "/proc/interrupts"

	local tbl = {}
	for str in io.lines(path) do
		local name, remainder = str:match(namepatt)
		if name then
			local numbers = remainder:match(numberspatt)
			local desc = remainder:match(descpatt)

			local cpu = 0;
			local valueTbl = {}
			for number in numbers:gmatch("%s*(%d+)") do
				--print("NUMBER: ", number)
				valueTbl["cpu"..cpu] = tonumber(number);
				cpu = cpu + 1;
			end
			valueTbl.description = desc
			tbl[name] = valueTbl

		end
	end

	return tbl
end

return {
	decoder = interrupts;
}