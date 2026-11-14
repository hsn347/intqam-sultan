criAdxMgr = class("criAdxMgr")
local adx
if cc.criAdx and cc.criAdx.Instance then
	adx = cc.criAdx:Instance()
end
function criAdxMgr:init()
	adx:init(gCriwareAdxDef.AcfPath, gCriwareAdxDef.MaxVoices, gCriwareAdxDef.MaxSamplingRate)
end
function criAdxMgr:destroy()
	adx:Destroy()
end
function criAdxMgr:loadAcb(fileName, acbPath, awbPath)
	adx:loadAcb(fileName, acbPath, awbPath)
end
function criAdxMgr:unloadAcb(fileName)
	adx:unloadAcb(fileName)
end
function criAdxMgr:playName(fileName, name, musicType)
	return adx:playName(fileName, name, musicType)
end
function criAdxMgr:switchSelector(fileName, selectorName, labelName, cueName, musicType)
	return adx:switchSelector(fileName, selectorName, labelName, cueName, musicType)
end
function criAdxMgr:pause(type, isPause)
	adx:pause(type, isPause)
end
function criAdxMgr:isPause(type)
	return adx:isPause(type)
end
function criAdxMgr:getUsedVoiceString()
	return adx:getUsedVoiceString()
end
function criAdxMgr:stop(type, isImmediately)
	adx:stop(type, isImmediately)
end
function criAdxMgr:stopMusicByID(id)
	adx:stopMusicByID(id)
end
function criAdxMgr:stopLastMusic(type)
	adx:stopLastMusic(type)
end
function criAdxMgr:setControlValue(type, controlName, value)
	adx:setControlValue(type, controlName, value)
end
function criAdxMgr:getPlayerStatus(type)
	return adx:getPlayerStatus(type)
end
function criAdxMgr:getMusicPlayingCount(fileName, name)
	return adx:getMusicPlayingCount(fileName, name)
end
function criAdxMgr:freeAudio()
	if adx.freeAudio then
		adx:freeAudio()
	end
end
function criAdxMgr:play3DName(fileName, name, tag3D, musicType)
	if adx.play3DName then
	end
	return 0
end
function criAdxMgr:set3DSourcePos(tag3D, x, y, z)
	if adx.set3DSourcePos then
	end
end
function criAdxMgr:set3DListionerPos(x, y, z)
	if adx.set3DListionerPos then
	end
end
return criAdxMgr
