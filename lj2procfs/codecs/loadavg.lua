local pattern = "(%d*.%d+)%s+(%d*.%d+)%s+(%d*.%d+)%s+(%d+)/(%d+)%s+(%d+)"

local function decoder(path)
	path = path or "/proc/loadavg"

	local f = io.open(path)
	local str = f:read("*a")
	f:close()

	local minute1avg, minute5avg, minute15avg, runnable, exist, lastpid = str:match(pattern)

	return {
		minute1avg = tonumber(minute1avg),
		minute5avg = tonumber(minute5avg),
		minute15avg = tonumber(minute15avg),
		runnable = tonumber(runnable),
		exist = tonumber(exist),
		lastpid = tonumber(lastpid)
	}

end

return {
	decoder = decoder;
}