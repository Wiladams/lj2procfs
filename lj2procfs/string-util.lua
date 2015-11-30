--string-util.lua

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

function F.trim(s)
	local from = s:match"^%s*()"
 	return from > #s and "" or s:match(".*%S", from)
end

return F
