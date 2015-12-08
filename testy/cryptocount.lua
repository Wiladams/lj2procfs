package.path = "../?.lua;"..package.path;

local fun = require("lj2procfs.fun")
local procfs = require("lj2procfs.procfs")

local crypts = procfs.crypto

print("Num of crypts: ", fun.length(crypts))


local function printEach(name, tbl)
	print(name, tbl.type)
end


local function isRng(name, tbl)
	return tbl.type == "rng"
end

fun.each(printEach, fun.filter(isRng, crypts))
