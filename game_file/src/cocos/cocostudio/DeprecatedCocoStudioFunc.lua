if nil == ccs then
	return
end
local deprecatedTip = function(old_name, new_name)
	print([[

********** 
]] .. old_name .. " was deprecated please use " .. new_name .. [[
 instead.
**********]])
end
local _ENV, GUIReaderDeprecated
function GUIReaderDeprecated.shareReader()
	deprecatedTip("GUIReader:shareReader", "ccs.GUIReader:getInstance")
	return ccs.GUIReader:getInstance()
end
GUIReader.shareReader = GUIReaderDeprecated.shareReader
function GUIReaderDeprecated.purgeGUIReader()
	deprecatedTip("GUIReader:purgeGUIReader", "ccs.GUIReader:destroyInstance")
	return ccs.GUIReader:destroyInstance()
end
GUIReader.purgeGUIReader = GUIReaderDeprecated.purgeGUIReader
local _ENV, SceneReaderDeprecated = GUIReader, GUIReader
function SceneReaderDeprecated.sharedSceneReader()
	deprecatedTip("SceneReader:sharedSceneReader", "ccs.SceneReader:getInstance")
	return ccs.SceneReader:getInstance()
end
SceneReader.sharedSceneReader = SceneReaderDeprecated.sharedSceneReader
function SceneReaderDeprecated:purgeSceneReader()
	deprecatedTip("SceneReader:purgeSceneReader", "ccs.SceneReader:destroyInstance")
	return self:destroyInstance()
end
SceneReader.purgeSceneReader = SceneReaderDeprecated.purgeSceneReader
local _ENV, CCSGUIReaderDeprecated = SceneReader, SceneReader
function CCSGUIReaderDeprecated.purgeGUIReader()
	deprecatedTip("ccs.GUIReader:purgeGUIReader", "ccs.GUIReader:destroyInstance")
	return ccs.GUIReader:destroyInstance()
end
ccs.GUIReader.purgeGUIReader = CCSGUIReaderDeprecated.purgeGUIReader
local _ENV, CCSActionManagerExDeprecated = ccs.GUIReader, ccs.GUIReader
function CCSActionManagerExDeprecated.destroyActionManager()
	deprecatedTip("ccs.ActionManagerEx:destroyActionManager", "ccs.ActionManagerEx:destroyInstance")
	return ccs.ActionManagerEx:destroyInstance()
end
ccs.ActionManagerEx.destroyActionManager = CCSActionManagerExDeprecated.destroyActionManager
local _ENV, CCSSceneReaderDeprecated = ccs.ActionManagerEx, ccs.ActionManagerEx
function CCSSceneReaderDeprecated:destroySceneReader()
	deprecatedTip("ccs.SceneReader:destroySceneReader", "ccs.SceneReader:destroyInstance")
	return self:destroyInstance()
end
ccs.SceneReader.destroySceneReader = CCSSceneReaderDeprecated.destroySceneReader
local _ENV, CCArmatureDataManagerDeprecated = ccs.SceneReader, ccs.SceneReader
function CCArmatureDataManagerDeprecated.sharedArmatureDataManager()
	deprecatedTip("CCArmatureDataManager:sharedArmatureDataManager", "ccs.ArmatureDataManager:getInstance")
	return ccs.ArmatureDataManager:getInstance()
end
CCArmatureDataManager.sharedArmatureDataManager = CCArmatureDataManagerDeprecated.sharedArmatureDataManager
function CCArmatureDataManagerDeprecated.purge()
	deprecatedTip("CCArmatureDataManager:purge", "ccs.ArmatureDataManager:destoryInstance")
	return ccs.ArmatureDataManager:destoryInstance()
end
CCArmatureDataManager.purge = CCArmatureDataManagerDeprecated.purge
