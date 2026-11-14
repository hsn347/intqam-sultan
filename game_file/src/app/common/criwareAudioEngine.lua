local M.soundEffectFileCheck, _ENV, _ENV, M
local criAdxAux = _G.criAdxAux
local criAdxMgr = _G.criAdxMgr
local MusicType = gCriwareAdxDef.MusicType
local playingMusic
function M.init()
	criAdxAux.init()
end
function M.getMusicVolume()
	local musicVolume = criAdxAux.getVolumePercentMusicType(MusicType.BGM)
	return musicVolume == nil and 0 or musicVolume
end
local transform_volume = function(value)
	value = value or 1
	if value < 0 then
		value = 0
	end
	if 1 < value then
		value = 1
	end
	return math.floor(value * 100)
end
function M.setMusicVolume(volume)
	local lastMusicVolume = M.getMusicVolume()
	local value = transform_volume(volume)
	criAdxAux.setVolumePercentMusicType(MusicType.BGM, value)
	if lastMusicVolume <= 0 and 0 < volume and playingMusic ~= nil then
		M.playMusic(playingMusic, true)
	end
	if volume <= 0 then
		M.stopMusic()
	end
end
function M.isMusicPlaying()
end
function M.playMusic(filename, isLoop)
	filename = {}
	return criAdxAux.playName(filename)
end
function M.stopMusic(isReleaseData)
	criAdxAux.stopMusicType(MusicType.BGM)
end
function M.preloadMusic(filename)
	criAdxAux.preloadName(filename)
end
function M.pauseMusic()
	criAdxAux.pauseMusicType(MusicType.BGM)
end
function M.resumeMusic()
	criAdxAux.restoreMusicType(MusicType.BGM)
end
function M.rewindMusic()
end
function M.willPlayMusic()
end
function M.playEffect(filename, isLoop, delay, tag3D)
	if _G.gIsGameSoundEffectMuted then
		return -1
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
	return criAdxAux.playName(filename, tag3D)
end
function M.preloadEffect(filename)
	criAdxAux.preloadName(filename)
end
function M.unloadEffect(filename)
end
function M.getEffectsVolume()
	return criAdxAux.getVolumePercentMusicType(MusicType.SOUND)
end
function M.setEffectsVolume(volume)
	_G.gIsGameSoundEffectMuted = volume <= 0
	local value = transform_volume(volume)
	criAdxAux.setVolumePercentMusicType(MusicType.SOUND, value)
	criAdxAux.setVolumePercentMusicType(MusicType.VOICE, value)
end
function M.pauseEffect(handle)
end
function M.resumeEffect(handle)
end
function M.pauseAllEffects()
	criAdxAux.pauseMusicType(MusicType.SOUND)
	criAdxAux.pauseMusicType(MusicType.VOICE)
end
function M.resumeAllEffects(handle)
	criAdxAux.restoreMusicType(MusicType.SOUND)
	criAdxAux.restoreMusicType(MusicType.VOICE)
end
function M.stopEffect(handle)
	if handle then
		criAdxAux.stopByID(handle)
	end
end
function M.stopAllEffects()
	criAdxAux.stopMusicType(MusicType.SOUND)
	criAdxAux.stopMusicType(MusicType.VOICE)
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
		local check = criAdxAux.isFileExist(filename)
		M.soundEffectFileCheck[filename] = check
		return check
	end
	return true
end
function M.getInstance()
	return M
end
function M.destroyInstance()
end
local isDebugOn = false
if isDebugOn then
	for k, v in pairs(M) do
		if type(v) == "function" then
			M[k] = function(...)
				print("[criwares]" .. k)
				_ENV = "[criwares]" .. k
				;("[criwares]" .. k)[1] = ...
				;("[criwares]" .. k)[2] = ...
				dump("[criwares]" .. k, "param", 10)
				return v(...)
			end
		end
	end
end
return M
