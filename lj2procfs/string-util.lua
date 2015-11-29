--string-util.lua

local F = {}

function F.startswith(s, prefix)
	return string.find(s, prefix, 1, true) == 1
end

-- returns true if string 's' ends with string 'send'
function F.endswith(s, send)
	return #s >= #send and string.find(s, send, #s-#send+1, true) and true or false
end


return F
