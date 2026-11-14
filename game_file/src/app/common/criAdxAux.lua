if not criAdxAux then
	_ENV = criAdxAux
end
criAdxAux = criAdxAux
local CriwareAdxDef = include("criwareAdxDef")
local criAdxRead = include("criAdxRead")
local MusicType = CriwareAdxDef.MusicType
;(nil).musicVolume, _ENV, _ENV = nil, nil, nil
;(nil).selectorInfo, _ENV, (nil).curLanguage = nil, nil, nil
local MusicRecordInfo
local _ENV, loadedAcbs
function criAdxAux.init()
	loadedAcbs = nil
	;({["curLanguage"] = nil}).musicVolume, loadedAcbs, loadedAcbs = nil, nil, {["curLanguage"] = nil}
	;({["curLanguage"] = nil}).selectorInfo, loadedAcbs = nil, nil
	criAdxMgr:destroy()
	criAdxAux.checkAcbConfig()
	local afcPath = cc.FileUtils:getInstance():fullPathForFilename(CriwareAdxDef.AcfPath)
	criAdxMgr:init(afcPath, CriwareAdxDef.MaxVoices, CriwareAdxDef.MaxSamplingRate)
end
function criAdxAux.reboot()
	criAdxAux.init()
end
function criAdxAux.loadLanguageAcb()
	local sLang = SoraDGetDefaultLanguage()
	local lanPath = CriwareAdxDef.LanguagePath[sLang]
	if not lanPath or lanPath == "" then
		lanPath = CriwareAdxDef.LanguagePath.default
		print(string.format("[CRIWARE ADX ERROR]:criAdxAux.loadLanguageAcb Language resource configuration does not exist [%s]", sLang and sLang or "nil"))
	end
	if MusicRecordInfo.curLanguage == lanPath then
		return
	end
	if MusicRecordInfo.curLanguage then
		criAdxAux.unloadAcbList(CriwareAdxDef.LanguageAcb)
	end
	MusicRecordInfo.curLanguage = lanPath
	criAdxAux.loadAcbList(CriwareAdxDef.LanguageAcb, lanPath)
end
function criAdxAux.initBatle()
	criAdxAux.unloadAcbList(CriwareAdxDef.MainAcb)
	criAdxAux.loadAcbList(CriwareAdxDef.BattleAcb)
end
function criAdxAux.quitBattle()
	criAdxAux.stopAll()
	criAdxAux.unloadAcbList(CriwareAdxDef.BattleAcb)
	criAdxAux.loadAcbList(CriwareAdxDef.MainAcb)
end
function criAdxAux.loadAcbList(acbList, lanPath)
	if type(acbList) ~= "table" then
		_UPVALUE1_ = type(acbList)
		acbList, type(acbList)[1] = type(acbList), acbList
	end
	for k, v in ipairs(acbList) do
		criAdxAux.preloadAcb(v, lanPath)
	end
end
function criAdxAux.unloadAcbList(acbList)
	if type(acbList) ~= "table" then
		_UPVALUE1_ = type(acbList)
		acbList, type(acbList)[1] = type(acbList), acbList
	end
	for k, v in ipairs(acbList) do
		criAdxAux.unloadAcb(v)
	end
end
function criAdxAux.playClick(name)
	name = name or "sound_common_button"
	criAdxAux.playName(name)
end
function criAdxAux.playName(name, tag3D)
	local fileName = criAdxRead.getCueFileName(name)
	if not criAdxAux.isLoadedAcb(fileName) then
		if fileName == "VO" then
			criAdxAux.loadLanguageAcb()
		else
			criAdxAux.preloadAcb(fileName)
		end
	end
	local type = fileName and criAdxRead.getAdxType(fileName)
	if type then
		if tag3D then
			return criAdxMgr:play3DName(fileName, name, tag3D, type)
		else
			return criAdxMgr:playName(fileName, name, type)
		end
	else
		print(string.format("[CRIWARE ADX ERROR]:criAdxAux.playName File not found [%s]", name and name or "nil"))
	end
end
function criAdxAux.playTest()
	local testCue = criAdxRead.getTestCue()
	for k, v in pairs(testCue) do
		criAdxAux.playName(v)
	end
end
function criAdxAux.switchSelector(fileName, selectorName, labelName)
	local adxInfo = criAdxRead.getAdxConfig(fileName)
	local cueName = criAdxRead.getSelectorCueName(fileName, selectorName)
	if adxInfo and cueName and labelName then
		if adxInfo.musicType == MusicType.BGM and labelName == MusicRecordInfo.selectorInfo[selectorName] and criAdxMgr:getMusicPlayingCount(fileName, cueName) > 0 then
			return
		end
		MusicRecordInfo.selectorInfo[selectorName] = labelName
		return criAdxMgr:switchSelector(fileName, selectorName, labelName, cueName, adxInfo.musicType)
	else
		print(string.format("[CRIWARE ADX ERROR]:criAdxAux.switchSelector Cue not found [%s] [%s] [%s]", fileName and fileName or "nil", selectorName and selectorName or "nil", labelName and labelName or "nil"))
	end
end
function criAdxAux.getPlayerStatus(type)
	return criAdxMgr:getPlayerStatus(type)
end
function criAdxAux.getMusicPlayingCount(name)
	local fileName = criAdxRead.getCueFileName(name)
	if fileName then
		return criAdxMgr:getMusicPlayingCount(fileName, name)
	else
		print(string.format("[CRIWARE ADX ERROR]:criAdxAux.getMusicPlayingCount File not found [%s]", name and name or "nil"))
	end
end
function criAdxAux.pauseMusicType(type)
	criAdxMgr:pause(type, true)
end
function criAdxAux.restoreMusicType(type)
	criAdxMgr:pause(type, false)
end
function criAdxAux.stopMusicType(type)
	criAdxMgr:stop(type)
end
function criAdxAux.stopByID(id)
	criAdxMgr:stopMusicByID(id)
end
function criAdxAux.stopLastMusic(type)
	criAdxMgr:stopLastMusic(type)
end
function criAdxAux.setVolumePercentMusicType(type, val)
	if MusicRecordInfo.musicVolume[type] == val then
		return
	end
	MusicRecordInfo.musicVolume[type] = val
	local volume = criAdxAux.parseVolumePercent(type, val)
	criAdxMgr:setControlValue(type, CriwareAdxDef.VolumeInfo[type].control, volume)
end
function criAdxAux.getVolumePercentMusicType(type)
	return MusicRecordInfo.musicVolume[type]
end
function criAdxAux.resetVolumeMusicType(type)
	local volumeInfo = CriwareAdxDef.VolumeInfo[type]
	criAdxAux.setVolumePercentMusicType(type, criAdxAux.parseVolumeValue(type, volumeInfo.default))
end
function criAdxAux.pauseAll()
	for k, v in pairs(CriwareAdxDef.MusicType) do
		criAdxAux.pauseMusicType(v)
	end
end
function criAdxAux.restoreAll()
	for k, v in pairs(CriwareAdxDef.MusicType) do
		criAdxAux.restoreMusicType(v)
	end
end
function criAdxAux.stopAll()
	for k, v in pairs(CriwareAdxDef.MusicType) do
		criAdxAux.stopMusicType(v)
	end
end
function criAdxAux.setAllVolumePercent(val)
	for k, v in pairs(CriwareAdxDef.MusicType) do
		criAdxAux.setVolumePercentMusicType(v, val)
	end
end
function criAdxAux.freeAudio()
	loadedAcbs = nil
	criAdxMgr:freeAudio()
	MusicRecordInfo.curLanguage = nil
	criAdxAux.loadLanguageAcb()
end
function criAdxAux.parseVolumePercent(type, percent)
	local volumeInfo = CriwareAdxDef.VolumeInfo[type]
	local range = volumeInfo.range
	local volume = range[1] + (range[2] - range[1]) * percent / 100
	return volume
end
function criAdxAux.parseVolumeValue(type, value)
	local range = CriwareAdxDef.VolumeInfo[type].range
	return (value - range[1]) / (range[2] - range[1]) * 100
end
function criAdxAux.getResPath(adxInfo, lanRes)
	lanRes = lanRes or ""
	local resPath = CriwareAdxDef.MusicPath[adxInfo.musicType]
	local acbPath = criAdxAux.getFullPath(string.format("%s%s%s.acb", resPath, lanRes, adxInfo.name))
	local awbPath
	if adxInfo.isExistAwb == 1 then
		awbPath = criAdxAux.getFullPath(string.format("%s%s%s.awb", resPath, lanRes, adxInfo.name))
	end
	return acbPath, awbPath
end
function criAdxAux.getFullPath(path)
	return path
end
function criAdxAux.isLoadedAcb(fileName)
	return loadedAcbs[fileName] or false
end
function criAdxAux.preloadName(name, lanPath)
	local fileName = criAdxRead.getCueFileName(name)
	criAdxAux.preloadAcb(fileName, lanPath)
end
function criAdxAux.preloadAcb(fileName, lanPath)
	local adxInfo = criAdxRead.getAdxConfig(fileName)
	if adxInfo then
		local resPath, awbPath = criAdxAux.getResPath(adxInfo, lanPath)
		criAdxMgr:loadAcb(adxInfo.name, resPath, awbPath)
		loadedAcbs[fileName] = true
	else
	end
end
function criAdxAux.unloadAcb(fileName)
	loadedAcbs[fileName] = false
	criAdxMgr:unloadAcb(fileName)
end
function criAdxAux.isFileExist(name)
	local fileName = criAdxRead.getCueFileName(name)
	if not fileName then
		return false
	end
	return true
end
function criAdxAux.checkAcbConfig()
	local cDef = CriwareAdxDef
	_UPVALUE4_ = nil
	;(nil)[1] = cDef.CommonAcb
	;(nil)[2] = cDef.MainAcb
	;(nil)[3] = cDef.BattleAcb
	local (nil)[4], tabList = cDef.LanguageAcb, nil
	local CriwareAdxDef, configHash = cDef.CommonAcb, cDef.CommonAcb
	local allConfig = criAdxRead.getAll()
	for _, tab in ipairs(tabList) do
		for _, v in ipairs(tab) do
			configHash[v] = v
		end
	end
	for _, v in pairs(configHash) do
		if not allConfig[v] then
			print(string.format("[CRIWARE ADX WARN]:criwareAdx_config.lua is missing [%s]", v))
		end
	end
	for k, _ in pairs(allConfig) do
		if not configHash[k] then
			print(string.format("[CRIWARE ADX WARN]:CriwareAdxDef.lua is missing [%s]", k))
		end
	end
end
