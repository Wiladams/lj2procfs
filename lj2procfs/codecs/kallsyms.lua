local function kallsyms(path)
	path = path or "/proc/kallsyms"

	local tbl = {}
	local pattern = "(%x+)%s+(%g+)%s+(%g+)"

	for str in io.lines(path)  do
		local loc, kind, name = str:match(pattern)
		if name then
			tbl[name] = {name = name, kind = kind, location = loc}
		end
	end

	return tbl
end

return {
	decoder = kallsyms;
}