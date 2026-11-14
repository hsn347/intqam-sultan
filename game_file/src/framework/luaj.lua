local _ENV, luaj
local callJavaStaticMethod = LuaJavaBridge.callStaticMethod
local checkArguments = function(args, sig)
	if type(args) ~= "table" then
		args, _ENV = type(args), type(args)
	end
	if sig then
		return args, sig
	end
	_UPVALUE1_ = args
	sig, args[1] = args, "("
	for i, v in ipairs(args) do
		local t = type(v)
		if t == "number" then
			sig[#sig + 1] = "F"
		elseif t == "boolean" then
			sig[#sig + 1] = "Z"
		elseif t == "function" then
			sig[#sig + 1] = "I"
		else
			sig[#sig + 1] = "Ljava/lang/String;"
		end
	end
	sig[#sig + 1] = ")V"
	return args, table.concat(sig)
end
function luaj.callStaticMethod(className, methodName, args, sig)
	local args, sig = checkArguments(args, sig)
	return callJavaStaticMethod(className, methodName, args, sig)
end
return luaj
