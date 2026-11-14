if nil == cc.SimpleAudioEngine then
	return
end
_ENV = cc.SimpleAudioEngine
DeprecatedCocosDenshionClass = cc.SimpleAudioEngine or DeprecatedCocosDenshionClass
local deprecatedTip = function(old_name, new_name)
	print([[

********** 
]] .. old_name .. " was deprecated please use " .. new_name .. [[
 instead.
**********]])
end
function DeprecatedCocosDenshionClass.SimpleAudioEngine()
	deprecatedTip("SimpleAudioEngine", "cc.SimpleAudioEngine")
	return cc.SimpleAudioEngine
end
_G.SimpleAudioEngine = DeprecatedCocosDenshionClass.SimpleAudioEngine()
