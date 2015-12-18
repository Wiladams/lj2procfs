local function devices(path)
	local devicepatt = "(%d+)%s+(.*)"
	local catpatt = "(%w+) devices:"
	local tbl = {}
	local catTbl = nil
	local category = nil;

	for str in io.lines(path) do

		if str == "" then		
			catTbl = nil;
		else
			category = str:match(catpatt)

			if category then
				print("New CAT: ", category)
				tbl[category] = {}
				catTbl = tbl[category]
			else
				local major, desc = str:match(devicepatt)
				if major then

					table.insert(catTbl, {major = tonumber(major), device = desc})	
				end	
			end
		end
	end

	return tbl;
end

return {
	decoder = devices;
}