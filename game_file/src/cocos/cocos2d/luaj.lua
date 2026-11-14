local _ENV, luaj
local callJavaStaticMethod = LuaJavaBridge.callStaticMethod
_ENV = nil
;(nil)[string.byte("F")] = 1
;(nil)[string.byte("Z")] = 1
;(nil)[string.byte("I")] = 1
local (nil)[string.byte("L")], arr = string.len("Ljava/lang/String;"), nil
local getArgumentsCount = function(sig)
	local sigArgs = string.match(sig, "^%((.*)%)")
	local len = string.len(sigArgs)
	local num = 0
	local left = len
	while 0 < left do
		local tmp = string.byte(sigArgs, -left)
		local i = arr[tmp]
		assert(i, "Invalid Jni sig")
		left = left - i
		num = num + 1
	end
	return num
end
local checkArguments = function(args, sig, className, methodName)
	if type(args) ~= "table" then
		args, _ENV = type(args), type(args)
	end
	assert(#args == table.nums(args), "Invalid Jni args")
	if sig then
		assert(#args == getArgumentsCount(sig), "Invalid Jni sigNum")
		return args, sig
	end
	getArgumentsCount = args
	sig, args[1] = args, "("
	for _, v in ipairs(args) do
		local t = type(v)
		if t == "number" then
			sig[#sig + 1] = "F"
		elseif t == "boolean" then
			sig[#sig + 1] = "Z"
		elseif t == "function" then
			sig[#sig + 1] = "I"
		elseif t == "string" then
			sig[#sig + 1] = "Ljava/lang/String;"
		else
			local errMsg = string.format("className: %s , methodName: %s", className, methodName)
			assert(false, errMsg)
		end
	end
	sig[#sig + 1] = ")V"
	return args, table.concat(sig)
end
function luaj.callStaticMethod(className, methodName, args, sig)
	local args, sig = checkArguments(args, sig, className, methodName)
	return callJavaStaticMethod(className, methodName, args, sig)
end
return luaj
