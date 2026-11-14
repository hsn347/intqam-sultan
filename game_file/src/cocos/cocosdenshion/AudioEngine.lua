if nil == cc.SimpleAudioEngine then
	return
end
local M.soundEffectFileCheck, _ENV, _ENV, M = nil, nil, cc.SimpleAudioEngine, cc.SimpleAudioEngine
function M.init()
end
function M.stopAllEffects()
	cc.SimpleAudioEngine:getInstance():stopAllEffects()
end
function M.getMusicVolume()
	return cc.SimpleAudioEngine:getInstance():getMusicVolume()
end
function M.isMusicPlaying()
	return cc.SimpleAudioEngine:getInstance():isMusicPlaying()
end
function M.getEffectsVolume()
	return cc.SimpleAudioEngine:getInstance():getEffectsVolume()
end
function M.setMusicVolume(volume)
	cc.SimpleAudioEngine:getInstance():setMusicVolume(volume)
end
function M.stopEffect(handle)
	cc.SimpleAudioEngine:getInstance():stopEffect(handle)
end
function M.stopMusic(isReleaseData)
	local releaseDataValue = false
	if nil ~= isReleaseData then
		releaseDataValue = isReleaseData
	end
	cc.SimpleAudioEngine:getInstance():stopMusic(releaseDataValue)
end
function M.playMusic(filename, isLoop)
	do return end
	local loopValue = false
	if nil ~= isLoop then
		loopValue = isLoop
	end
	cc.SimpleAudioEngine:getInstance():playMusic(filename, loopValue)
end
function M.pauseAllEffects()
	cc.SimpleAudioEngine:getInstance():pauseAllEffects()
end
function M.preloadMusic(filename)
	cc.SimpleAudioEngine:getInstance():preloadMusic(filename)
end
function M.resumeMusic()
	cc.SimpleAudioEngine:getInstance():resumeMusic()
end
function M.setLastPlayData(_filename, _lastTime)
	M, _filename = nil, _filename or ""
	;(nil).filename = _filename
	M.lastPlayData, (nil).lastTime = nil, _lastTime
end
function M.getLastPlayData()
	if not M.lastPlayData then
		M = M.lastPlayData
		M.lastPlayData.filename = ""
		M.lastPlayData.lastTime = 0
	end
	return M.lastPlayData
end
function M.checkEffectFileExist(filename)
	if not M.soundEffectFileCheck.filename then
		local check = cc.FileUtils:getInstance():isFileExist(filename) or SoraDIsFileExistByKey(filename)
		M.soundEffectFileCheck[filename] = check
		return check
	end
	return true
end
function M.playEffect(filename, isLoop, delay)
	if gIsGameSoundEffectMuted then
		return -1
	end
	local loopValue = false
	if nil ~= isLoop then
		loopValue = isLoop
	end
	local curTime = os.clock()
	local lastPlayData = M.getLastPlayData()
	local screenDelay = 0.1
	if delay and type(delay) == "number" then
		screenDelay = delay
	end
	if lastPlayData.filename == filename and screenDelay >= curTime - lastPlayData.lastTime then
		print("===================偏差值", curTime - lastPlayData.lastTime)
		print("===================疑似双响，已过滤", filename)
		return -1
	end
	if delay then
		M.setLastPlayData(filename, curTime)
	else
		M.setLastPlayData("", 0)
	end
	return cc.SimpleAudioEngine:getInstance():playEffect(filename, loopValue)
end
function M.rewindMusic()
	cc.SimpleAudioEngine:getInstance():rewindMusic()
end
function M.willPlayMusic()
	return cc.SimpleAudioEngine:getInstance():willPlayMusic()
end
function M.unloadEffect(filename)
	cc.SimpleAudioEngine:getInstance():unloadEffect(filename)
end
function M.preloadEffect(filename)
	if isDisableEffect() then
		return
	end
	cc.SimpleAudioEngine:getInstance():preloadEffect(filename)
end
function M.setEffectsVolume(volume)
	gIsGameSoundEffectMuted = volume <= 0
	cc.SimpleAudioEngine:getInstance():setEffectsVolume(volume)
end
function M.pauseEffect(handle)
	cc.SimpleAudioEngine:getInstance():pauseEffect(handle)
end
function M.resumeAllEffects(handle)
	cc.SimpleAudioEngine:getInstance():resumeAllEffects()
end
function M.pauseMusic()
	cc.SimpleAudioEngine:getInstance():pauseMusic()
end
function M.resumeEffect(handle)
	cc.SimpleAudioEngine:getInstance():resumeEffect(handle)
end
function M.getInstance()
	return cc.SimpleAudioEngine:getInstance()
end
function M.destroyInstance()
	return cc.SimpleAudioEngine:destroyInstance()
end
AudioEngine__ = M
