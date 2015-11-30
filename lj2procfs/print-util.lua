local function literalForValue(avalue)
	if type(avalue) == "number" or type(avalue) == "boolean" then
		return tostring(avalue)
	end

	local str = tostring(avalue)
	if str == "" then
		return "''"
	end

	return string.format("[[%s]]", str)
end

local function printValue(avalue, indent, name)
	indent = indent or ""

	if type(avalue) == "table" then
		if name then
			print(string.format("%s['%s'] = {", indent, name))
		else
			print(string.format("%s{", indent))
		end

		if #avalue > 0 then
			-- it's a list,so use ipairs
			for _, value in ipairs(avalue) do
				printValue(value, indent..'    ')
			end
		else
			-- assume it's a dictionary, so use pairs
			for key, value in pairs(avalue) do
				printValue(value, indent..'    ', key)
			end
		end
		print(string.format("%s};", indent))
	else 
		if name then
			print(string.format("%s%s = %s,", indent, name, literalForValue(avalue)))
		else
			print(string.format("%s%s,", indent, literalForValue(avalue)))
		end
	end

end

return {
	printValue = printValue;
}