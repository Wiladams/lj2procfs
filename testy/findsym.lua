#!/usr/bin/env luajit
package.path = "../?.lua;"..package.path;

--[[
	Find a kernel symbol located in the /proc/kallsyms file.
--]]

local sym = arg[1]
assert(sym, "must specify a symbol")

local putil = require("lj2procfs.print-util")
local sutil = require("lj2procfs.string-util")
local fun = require("lj2procfs.fun")
local procfs = require("lj2procfs.procfs")

local kallsyms = procfs.kallsyms

local function isDesiredSymbol(name, tbl)
    return sutil.startswith(name, sym)
end

local function printSymbol(name, value)
	putil.printValue(value)
end

fun.each(printSymbol, fun.filter(isDesiredSymbol, kallsyms))