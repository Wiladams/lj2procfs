--string-util.lua
local ffi = require("ffi")
local fun = require("lj2procfs.fun")

local floor = math.floor;


local F = {}

function F.startswith(s, prefix)
	return string.find(s, prefix, 1, true) == 1
end

-- returns true if string 's' ends with string 'send'
function F.endswith(s, send)
	return #s >= #send and string.find(s, send, #s-#send+1, true) and true or false
end



local function gsplit(s,sep)
	--print('gsplit: ', #sep, string.byte(sep[0]))
	return coroutine.wrap(function()
		if s == '' or sep == '' then coroutine.yield(s) return end
		local lasti = 1
		for v,i in s:gmatch('(.-)'..sep..'()') do
		   coroutine.yield(v)
		   lasti = i
		end
		coroutine.yield(s:sub(lasti))
	end)
end

local function iunpack(i,s,v1)
   local function pass(...)
	  local v1 = i(s,v1)
	  if v1 == nil then return ... end
	  return v1, pass(...)
   end
   return pass()
end

function F.split(s,sep)
   return iunpack(gsplit(s,sep))
end

local function accumulate(t,i,s,v)
    for v in i,s,v do
        t[#t+1] = v
    end
    return t
end

function F.tsplit(s,sep)
   return accumulate({}, gsplit(s,sep))
end

function F.tsplitbool(s, sep)
	local tbl={}
	for v in gsplit(s,sep) do
		tbl[v] = true;
	end
	return tbl
end

function F.trim(s)
	local from = s:match"^%s*()"
 	return from > #s and "" or s:match(".*%S", from)
end


-- a nil generator.  
-- good for cases when there's no data
local function nil_gen(param, state)
    return nil
end

local function delim_gen(param, idx)
	local len = 0;

	while ((idx+len) < param.nelems) do
		--print("wchar: ", string.char(ffi.cast(param.basetypeptr, param.data)[idx + len]))
		if ffi.cast(param.basetypeptr, param.data)[idx + len] ~= param.separator then
			len = len + 1;
		else
			break
		end
	end
	
	if len == 0 then
		return nil;
	end

	return idx + len + 1, ffi.cast(param.basetypeptr, param.data)+idx, len
end


local function array_gen(param, idx)
	if idx >= param.nelems then
		return nil;
	end

	return idx+1, ffi.cast(param.basetypeptr, param.data)+idx, 1
end


function F.striter(params)
	if not params then
		return nil_gen, params, nil
	end

	if not params.data then
		return nil_gen, params, nil
	end

	params.datalength = params.datalength or #params.data
	if params.basetype then
		if type(params.basetype)== "string" then
			params.basetype = ffi.typeof(params.basetype)
		end
	end
	params.basetype = params.basetype or ffi.typeof("char")
	params.basetypeptr = ffi.typeof("const $ *", params.basetype)
	params.basetypesize = ffi.sizeof(params.basetype)
	params.nelems = math.floor(params.datalength / params.basetypesize)

	if params.separator ~= nil then
		return delim_gen, params, 0
	else
		return array_gen, params, 0
	end

	return nil_gen, nil, nil
end

function F.mstriter(data, separator, datalength)
	return fun.map(function(ptr,len) return ffi.string(ptr, len) end, 
		striter({data = data, datalength = datalength, separator=separator, basetype="char"}))
end

-- an iterator over a string, with embedded
-- '\0' bytes delimiting strings
function F.mstrziter(data, datalength)
	datalength = datalength or #data

	return fun.map(function(ptr,len) return ffi.string(ptr, len) end, 
		striter({data = data, datalength = datalength, separator=0, basetype="char"}))
end

-- given a unicode string which contains
-- null terminated strings
-- return individual ansi strings
function F.wmstrziter(data, datalength)

	local maxLen = 255;
	local idx = -1;

	local nameBuff = ffi.new("char[256]")

	local function closure()
		idx = idx + 1;
		local len = 0;

		while len < maxLen do 
			print("char: ", string.char(lpBuffer[idx]))
			if data[idx] == 0 then
				break
			end
		
			nameBuff[len] = data[idx];
			len = len + 1;
			idx = idx + 1;
		end

		if len == 0 then
			return nil;
		end

		return ffi.string(nameBuff, len);
	end

	return closure;
end

return F
