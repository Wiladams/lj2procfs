#!/usr/bin/env luajit
--[[ This util prints proc info in JSON format.
     Usage: ./json-util.lua stat
            ./json-util.lua meminfo
            ./json-util.lua cpuinfo
    ]]--

local function literalForValue(avalue)
    if type(avalue) == "number" or type(avalue) == "boolean" then
        return tostring(avalue)
    end

    local str = tostring(avalue)
    if str == "" then
        return "''"
    end

    return string.format("%s", str)
end

local function printValueJson(avalue, indent, name)
    if not avalue then return end;

    indent = indent or ""

    if type(avalue) == "table" then
        local list = false
        if name then
            io.write(string.format("%s\"%s\": ", indent, name))
        end

        if #avalue > 0 then
            -- it's a list,so use ipairs
            io.write(string.format("["))
            list = true
            -- print comma at the end of line only if the next ipair is not nil
            for _, value in ipairs(avalue) do
                printValueJson(value, indent..'    ')
                if next(avalue, _) then
                    io.write(string.format(",\n"))
                end
            end
            io.write(string.format("]\n"))
        else
            -- assume it's a dictionary, so use pairs
            io.write(string.format("{\n"))
            for key, value in pairs(avalue) do
                printValueJson(value, indent..'    ', key)
                if next(avalue, key) then
                    io.write(string.format(","))
                end
                io.write(string.format("\n"))
            end
        end
        if not list then
            io.write(string.format("%s}", indent))
        end 
    else 
        if name then
            io.write(string.format("%s\"%s\" :\"%s\"", indent, name, literalForValue(avalue)))
        else
            io.write(string.format("%s%s,\n", indent, literalForValue(avalue)))
        end
    end
end

-- Calling the print util here: 
local procfs = require("lj2procfs.procfs")
local filename = nil
local PID = nil

if tonumber(arg[1]) then
    PID = tonumber(arg[1])
    filename = arg[2]
else
    filename = arg[1]
end

if not filename then USAGE() end

io.write("{\n")
if PID then
    printValueJson(procfs[PID][filename], '    ', tostring(PID).."_"..filename)
else
    printValueJson(procfs[filename], "    ", filename)
end
io.write("\n}\n")
