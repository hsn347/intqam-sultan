local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildBaseEntity = include("cityBuildBaseEntity")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local cityBuildMastery = class("cityBuildMastery", function()
	return cityBuildBaseEntity.new()
end)
function cityBuildMastery:ctor()
	self:setBuildIndex(cityBuildConstDef.fixedBuildDef.Mastery)
	self.bid = cityBuildConstDef.fixedBuildDef.Mastery
	print("create cityBuildMastery ", self.bid)
end
function cityBuildMastery:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_MASTERY_VIEW", handler(self, self.msgUpdateView))
	self:updateView()
end
function cityBuildMastery:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("specialization_text_01"), i18n("specialization_text_01")
	i18n("specialization_text_01").x = 0
	;(nil).pos, i18n("specialization_text_01").y = i18n("specialization_text_01"), -90
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildMastery:msgUpdateView(target, data)
	print("接收到消息 MESSAGE_MAINCITYVIEW_UPDATE_MASTERY_VIEW")
	self:updateView()
end
function cityBuildMastery:updateView()
	self:updateIsLock()
	if self:getIsUpgrading() then
		self:showAnimWorking()
		self:hideNormalPicture()
		self:hideZAnimation()
	else
		self:hideAnimWorking()
		self:showNormalPicture()
		self:showZAnimation()
	end
	self:updateCoolingPanel()
end
function cityBuildMastery:showNormalPicture(...)
	local nodeName = "buildNormalPicture"
	if not self[nodeName] then
		self:loadNodeByName(nodeName)
	end
	if self[nodeName] then
		self[nodeName]:setVisible(true)
	end
end
function cityBuildMastery:hideNormalPicture(...)
	local nodeName = "buildNormalPicture"
	if self[nodeName] then
		self[nodeName]:setVisible(false)
	end
end
function cityBuildMastery:updateCoolingPanel()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_MASTERY_COOLING_PANEL"
	;(nil).buildIndex = self.buildIndex
	;(nil).buildEntity = self
	SoraDSendMessage(nil)
end
function cityBuildMastery:getQueue(...)
	return queueCtrl:queryQueue(gQueueTypeDef.build_mastery)
end
function cityBuildMastery:getIsLocked(...)
	return SoraDGetCastleLv() < CASTLE_LV15_LIMITED
end
function cityBuildMastery:getIsUpgrading(...)
	return self:getQueue()
end
return cityBuildMastery
