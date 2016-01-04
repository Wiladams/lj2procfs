#!/usr/bin/env luajit

package.path = "../?.lua"

--[[
    test_sysinfo.lua

    Test for a specific directory
--]]

local procfs = require("lj2procfs.procfs")
local sutil = require("lj2procfs.string-util")
local sysfs = require("lj2procfs.codecs.sys")
local putil = require("lj2procfs.print-util")



local node = sysfs.sysfs("/sys/power");

for a, snode, c in pairs(node) do
    putil.printValue(snode)
end

