if cc.bPlugin_ then
	local _ENV, luaoc = cc.bPlugin_, cc.bPlugin_
	function luaoc.callStaticMethod(className, methodName, args)
		return false, nil
	end
	_G.luaoc = luaoc
else
end
