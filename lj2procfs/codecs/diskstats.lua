-- The field names used here are the same as for the iostat
-- program.
-- That program uses a 'struct io_stats'
-- Here we simply use a lua table

local function decoder(path)
	path = path or "/proc/diskstats"

	local tbl = {}

	-- If you were using 'C', this would be a 'scanf' template
	local pattern = "(%d+)%s+(%d+)%s+(%g+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)"
	
	-- The statistics are gathered for all devices, whether they are actual
	-- devices, partitions, or virtual devices.  Something else can determine
	-- which of these are to be filtered out.
	for str in io.lines(path) do

		local major, minor, dev_name,
			   rd_ios, rd_merges_or_rd_sec, rd_sec_or_wr_ios, rd_ticks_or_wr_sec,
			   wr_ios, wr_merges, wr_sec, wr_ticks, ios_pgr, tot_ticks, rq_ticks = str:match(pattern)

		-- add entry to table
		tbl[dev_name] = {
			major = tonumber(major), 
			minor = tonumber(minor), 
			rd_ios = tonumber(rd_ios), 
			rd_merges_or_rd_sec = tonumber(rd_merges_or_rd_sec), 
			rd_sec_or_wr_ios = tonumber(rd_sec_or_wr_ios), 
			rd_ticks_or_wr_sec = tonumber(rd_ticks_or_wr_sec),
			wr_ios = tonumber(wr_ios), 
			wr_merges = tonumber(wr_merges), 
			wr_sec = tonumber(wr_sec), 
			wr_ticks = tonumber(wr_ticks), 
			ios_pgr = tonumber(ios_pgr), 
			tot_ticks = tonumber(tot_ticks), 
			rq_ticks = tonumber(rq_ticks)
		}
	end

	return tbl;
end

return {
	decoder = decoder;
}