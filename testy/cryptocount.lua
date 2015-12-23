#!/usr/bin/env luajit
package.path = "../?.lua;"..package.path;

local fun = require("lj2procfs.fun")
local procfs = require("lj2procfs.procfs")

local crypts = procfs.crypto



local function printEach(name, tbl)
	print(string.format("%20s %s", name, tbl.type))
end


local function printRNGs()
	local function isRng(name, tbl)
		return tbl.type == "rng"
	end

	print("== RNGs ==")
	fun.each(printEach, fun.filter(isRng, crypts))
end

local function printCipher()
	local function isCipher(name, tbl)
		return tbl.type:find("cipher")
	end

	print("== Ciphers ==")
	fun.each(printEach, fun.filter(isCipher, crypts))
end

local function printHashes()
	local function isHash(name, tbl)
		return tbl.type:find("hash")
	end

	print("== Hashes ==")
	fun.each(printEach, fun.filter(isHash, crypts))
end

local function printAll()
	print("Number of crypts: ", fun.length(crypts))
	
---[[
	printCipher();
	printHashes();
	printRNGs();
--]]
	--fun.each(printEach, crypts)
end

printAll();