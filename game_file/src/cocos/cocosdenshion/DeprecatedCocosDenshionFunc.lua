if nil == cc.SimpleAudioEngine then
	return
end
local deprecatedTip = function(old_name, new_name)
	print([[

********** 
]] .. old_name .. " was deprecated please use " .. new_name .. [[
 instead.
**********]])
end
local _ENV, SimpleAudioEngineDeprecated
function SimpleAudioEngineDeprecated.sharedEngine()
	deprecatedTip("SimpleAudioEngine:sharedEngine", "SimpleAudioEngine:getInstance")
	return cc.SimpleAudioEngine:getInstance()
end
SimpleAudioEngine.sharedEngine = SimpleAudioEngineDeprecated.sharedEngine
function SimpleAudioEngineDeprecated:playBackgroundMusic(...)
	deprecatedTip("SimpleAudioEngine:playBackgroundMusic", "SimpleAudioEngine:playMusic")
	return self:playMusic(...)
end
SimpleAudioEngine.playBackgroundMusic = SimpleAudioEngineDeprecated.playBackgroundMusic
