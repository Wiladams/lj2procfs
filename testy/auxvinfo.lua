package.path = "../?.lua"

assert(arg[1])

local putil = require("lj2procfs.print-util")
local auxv = require("lj2procfs.codecs.process.auxv")

local path = "/proc/"..arg[1].."/auxv"
local tbl = auxv.decoder(path)

putil.printValue(tbl)