local gametop = gModuleMgr.getObject("gametop")
local treviFountainCtrl = gametop.playertop_:getModule("treviFountainCtrl")
local endlessTreasureCtrl = gametop.playertop_:getModule("endlessTreasureCtrl")
local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildWishingWell = class("cityBuildWishingWell", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildWishingWell:ctor()
end
function cityBuildWishingWell:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_114"), i18n("buildDes_name_114")
	i18n("buildDes_name_114").x = 0
	;(nil).pos, i18n("buildDes_name_114").y = i18n("buildDes_name_114"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildWishingWell:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_WISHINGWELL_VIEW", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_TREVIFOUNTAIN_ENDLESSTREASURE_REFRESH", handler(self, self.msgUpdateView))
end
function cityBuildWishingWell:msgUpdateView(target, data)
	local buildState = self:getBuildState()
	if buildState == BUILD_STATE.BUILDING then
		return
	end
	self:updateView()
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_BUILD_TIP_BOX"
	SoraDSendMessage(self)
end
function cityBuildWishingWell:updateView()
	local huntCount = self:getTimes()
	local isReward = self:isHaveReward()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_ENDLESSTREASURE_COOLING_PANEL"
	;(nil).buildIndex = self:getBuildIndex()
	;(nil).buildEntity = self
	SoraDSendMessage(nil)
	if isReward then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_ENDLESSTREASURE_TOP_TIP"
		SoraDSendMessage(nil)
	else
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_ENDLESSTREASURE_TOP_TIP"
		SoraDSendMessage(nil)
	end
	if 0 < huntCount then
		self:hideBright()
		self:showNormal()
	else
		self:hideNormal()
		self:showBright()
	end
end
function cityBuildWishingWell:isHaveReward()
	return endlessTreasureCtrl:isHaveRewardTreasure()
end
function cityBuildWishingWell:isShowDig()
	local isHaveDig = endlessTreasureCtrl:isHaveDigTreasure()
	local isHaveReward = endlessTreasureCtrl:isHaveRewardTreasure()
	return isHaveDig and not isHaveReward
end
function cityBuildWishingWell:getTimes()
	return treviFountainCtrl:getTreviFountainMultipleTimes()
end
function cityBuildWishingWell:showNormal()
end
function cityBuildWishingWell:hideNormal()
	if self.normalEffect then
		self.normalEffect:setVisible(false)
	end
end
function cityBuildWishingWell:showBright()
end
function cityBuildWishingWell:hideBright()
	if self.brightEffect then
		self.brightEffect:setVisible(false)
	end
end
return cityBuildWishingWell
