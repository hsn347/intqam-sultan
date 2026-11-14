local mainCityDefine = include("mainCityDefine")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildMiracle = class("cityBuildMiracle", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildMiracle:ctor()
	self.buildIndex = cityBuildConstDef.buildIndexDef.index_Miracle
	print("create Miracle!!")
end
function cityBuildMiracle:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_301"), i18n("buildDes_name_301")
	i18n("buildDes_name_301").x = 0
	;(nil).pos, i18n("buildDes_name_301").y = i18n("buildDes_name_301"), -20
	SoraDShowNameOnTouchEvent(self, nil)
	print("奇迹建筑初始化----")
end
function cityBuildMiracle:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_MIRACLE_VIEW", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_UNLOCK_UPDATE", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_WAKE_BACK", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_MERGE_BACK", handler(self, self.msgUpdateView))
	self:updateView()
end
function cityBuildMiracle:msgUpdateView(target, data)
	print("接收到消息 MESSAGE_MAINCITYVIEW_UPDATE_MIRACLE_VIEW")
	self:updateView()
end
function cityBuildMiracle:updateView()
	self:checkGodEquipPrompt()
end
function cityBuildMiracle:onAfterReconnected()
	self:updateView()
end
function cityBuildMiracle:checkGodEquipPrompt()
end
function cityBuildMiracle:hasEquipPrompt()
	return false
end
function cityBuildMiracle:isCustomIdle()
	local isIdle = true
	if self:getIsLocked() then
		isIdle = false
	end
	if isIdle and self:hasEquipPrompt() then
		isIdle = false
	end
	return isIdle
end
function cityBuildMiracle:updateViewAfterReset()
	self:updateTopTip()
end
function cityBuildMiracle:updateTopTip()
	print("cityBuildMiracle:updateTopTip()-----")
	self:checkGodEquipPrompt()
end
return cityBuildMiracle
