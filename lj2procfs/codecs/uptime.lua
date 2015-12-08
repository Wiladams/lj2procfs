--[[
	seconds idle 

	The first value is the number of seconds the system has been up.
	The second number is the accumulated number of seconds all processors
	have spent idle.  The second number can be greater than the first
	in a multi-processor system.
--]]
local function decoder(path)
	path = path or "/proc/uptime"
	-- open the file
	-- return full contents as a string
	local f = io.open(path)
	local str = f:read("*a")
	f:close()

	local seconds, idle = str:match("(%d*%.?%d+)%s+(%d*%.?%d+)")
	return {
		seconds = tonumber(seconds);
		idle = tonumber(idle);
	}

end

return {
	decoder = decoder;
}