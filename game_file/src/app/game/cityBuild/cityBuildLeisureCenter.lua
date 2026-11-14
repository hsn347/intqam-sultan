local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildConstDef = include("cityBuildConstDef")
local funUnlockRead = include("funUnlockRead")
local cityBuildLeisureCenter = class("cityBuildLeisureCenter", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildLeisureCenter:ctor()
	self:setBuildIndex(cityBuildConstDef.fixedBuildDef.LeisureCenter)
	self.bid = cityBuildConstDef.fixedBuildDef.LeisureCenter
end
function cityBuildLeisureCenter:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_LeisureCenter_VIEW", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_PYRAMID_ACTIVITY", handler(self, self.msgUpdateTopTip))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_UPDATE_TIP", handler(self, self.msgUpdateTopTip))
	SoraDAddMessage(self, "MESSAGE_SERVER_PAVILION_UPDATE_TIP", handler(self, self.msgUpdateTopTip))
	self:updateView()
end
function cityBuildLeisureCenter:loadView()
	self:loadBaseView()
	self:updateTopTip()
	_ENV = nil
	_ENV, (nil).name = i18n("common_text_1138"), i18n("common_text_1138")
	i18n("common_text_1138").x = 20
	;(nil).pos, i18n("common_text_1138").y = i18n("common_text_1138"), -10
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildLeisureCenter:msgUpdateView(target, data)
	print("接收到消息 MESSAGE_MAINCITYVIEW_UPDATE_LeisureCenter_VIEW")
	self:updateView()
end
function cityBuildLeisureCenter:updateView()
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidCtrl = gametop.playertop_:getModule("pyramidCtrl")
	if not pyramidCtrl then
		return
	end
	local isNeedShowEffect = false
	local freeTimes = pyramidCtrl:getFreeTime()
	if not freeTimes then
		return
	end
	if 0 < freeTimes then
		isNeedShowEffect = true
	end
	if isNeedShowEffect == false then
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local ret = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.PYRAMIDACTIVITY)
		if ret then
			isNeedShowEffect = true
		end
	end
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_NORMAL then
		if commonCheck.LEISURE_CENTER_EFFECT or isNeedShowEffect then
			self:showGlow()
			self:showBrightParticle()
		end
	else
		self:hideGlow()
		self:hideBrightParticle()
	end
end
function cityBuildLeisureCenter:msgUpdateTopTip(target, data)
	self:updateTopTip()
end
function cityBuildLeisureCenter:updateTopTip()
	if self:hasInvite() then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		self.buildIndex = self:getBuildIndex()
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		self.buildIndex = self:getBuildIndex()
		self.buildEntity = self
		self.buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_FRIEND_APPLY
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_HIDE_BUILD_TIP_BOX"
		self.buildIndex = self:getBuildIndex()
		SoraDSendMessage(self)
	elseif self:hasPyramidActivity() then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		self.buildIndex = self:getBuildIndex()
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		self.buildIndex = self:getBuildIndex()
		self.buildEntity = self
		self.buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_PYRAMID_ACTIVITY
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_HIDE_BUILD_TIP_BOX"
		self.buildIndex = self:getBuildIndex()
		SoraDSendMessage(self)
	elseif self:hasPavilionReward() then
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		self.buildIndex = self:getBuildIndex()
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		self.buildIndex = self:getBuildIndex()
		self.buildEntity = self
		self.buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_PAVILION_ACTIVITY
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_HIDE_BUILD_TIP_BOX"
		self.buildIndex = self:getBuildIndex()
		SoraDSendMessage(self)
	else
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		self.buildIndex = self:getBuildIndex()
		SoraDSendMessage(self)
	end
end
function cityBuildLeisureCenter:hasPavilionReward()
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.FOREIGNPAVILION)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY) and unlockLv <= SoraDGetCastleLv() then
		return not SoraDGetCtrl("exoticPavilionCtrl"):getIsGetDailyReward()
	end
	return false
end
function cityBuildLeisureCenter:hasPyramidActivity()
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.PYRAMID)
	local ret = SoraDGetCtrl("activityShowCtrl"):isActivityOpen(gActivityTimeActivityID.PYRAMIDACTIVITY) and unlockLv <= SoraDGetCastleLv()
	return ret
end
function cityBuildLeisureCenter:hasInvite()
	local contactCtrl = SoraDGetCtrl("contactCtrl")
	local inviteMap = contactCtrl:getRecvInviteMap()
	return next(inviteMap) ~= nil
end
function cityBuildLeisureCenter:showPyramid()
	local cityCtrl = SoraDGetCtrl("cityCtrl")
	local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
	if not castleBcell then
		return
	end
	local castleLV = castleBcell.info.lv
	if tonumber(castleLV) < CASTLE_LV8_LIMITED then
		local spriteName = "#btn_pyramid.png"
		_ENV = nil
		;(nil).blv = CASTLE_LV8_LIMITED
		SoraDShowMsgTip(i18n("common_text_1151", nil), spriteName)
	else
		uiManager:show("pyramidMain")
	end
end
function cityBuildLeisureCenter:canShowTopTipBox()
	if self:hasInvite() or self:hasPyramidActivity() then
		return false
	end
	return true
end
return cityBuildLeisureCenter
