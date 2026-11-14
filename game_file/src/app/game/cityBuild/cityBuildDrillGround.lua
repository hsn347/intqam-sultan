local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildDrillGround = class("cityBuildDrillGround", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildDrillGround:ctor()
end
function cityBuildDrillGround:onMessageListener(...)
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgUpdateMarketView))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_BUILDGUIDE", handler(self, self.msgUpdateMarketGuide))
	SoraDAddMessage(self, "MESSAGE_SERVER_ARENA_TIPCHANGE", handler(self, self.msgUpdateDrillArenaAuction))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_DRILL_VIEW", handler(self, self.msgUpdateMarketView))
end
function cityBuildDrillGround:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_121"), i18n("buildDes_name_121")
	i18n("buildDes_name_121").x = 0
	;(nil).pos, i18n("buildDes_name_121").y = i18n("buildDes_name_121"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildDrillGround:onAfterInitWithBuildCell()
	print("市场拍卖行金币检测---------")
	self:checkDrillArenaAuction()
end
function cityBuildDrillGround:hasGuide()
	local gametop = gModuleMgr.getObject("gametop")
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local isGuideNotComplete = guideCtrl:isGuideNotCompleted(gGuideModule.ARENA)
	local hasGuide
	if isGuideNotComplete and self:isConRight() then
		hasGuide = true
	else
		hasGuide = false
	end
	if self:getState() ~= "idle" then
		hasGuide = false
	end
	return hasGuide
end
function cityBuildDrillGround:isConRight(...)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local cLevel = cityCtrl:getBuildMaxLv(BUILDID.DRILL_GROUDS)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local isOpen = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.ARENA_ACTIVITY)
	if cLevel >= CASTLE_LV16_LIMITED and isOpen and lordInfoCtrl:getSourceKid() <= 0 then
		return true
	end
	return false
end
function cityBuildDrillGround:isCustomIdle()
	local isIdle = true
	if self:getIconType() > 0 then
		isIdle = false
	end
	return isIdle
end
function cityBuildDrillGround:getIconType()
	local ret = 0
	local gametop = gModuleMgr.getObject("gametop")
	local arenaCtrl = gametop.playertop_:getModule("arenaCtrl")
	local localIconType = arenaCtrl:getTipState(gArenaBattleType.ARENA_LOCAL)
	local globalIconType = arenaCtrl:getTipState(gArenaBattleType.AREAN_GLOBAL)
	if localIconType and globalIconType then
		ret = localIconType > globalIconType and localIconType or globalIconType
	elseif localIconType then
		ret = localIconType
	elseif globalIconType then
		ret = globalIconType
	end
	return ret
end
function cityBuildDrillGround:checkDrillArenaAuction()
	local hasGuide = self:hasGuide()
	if hasGuide or not self:isConRight() then
		print("竞技场有引导按钮，不显示金币")
		_ENV = "竞技场有引导按钮，不显示金币"
		;("竞技场有引导按钮，不显示金币").msg = "MESSAGE_MAINCITYVIEW_REMOVE_DRILL_ARENA_TOP_TIP"
		SoraDSendMessage("竞技场有引导按钮，不显示金币")
		return
	end
	local iconType = self:getIconType()
	if 0 < iconType then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_ADD_DRILL_ARENA_TOP_TIP"
		;(nil).iconType = iconType
		SoraDSendMessage(nil)
	else
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_DRILL_ARENA_TOP_TIP"
		SoraDSendMessage(nil)
	end
end
function cityBuildDrillGround:msgUpdateDrillArenaAuction(target, data)
	self:checkDrillArenaAuction()
end
function cityBuildDrillGround:msgUpdateMarketGuide(target, data)
	self:checkGuide()
end
function cityBuildDrillGround:msgUpdateMarketView(target, data)
	self:checkGuide()
	self:checkDrillArenaAuction()
end
function cityBuildDrillGround:checkGuide()
	local hasGuide = self:hasGuide()
	print("cityBuildDrillGround hasGuide = ", hasGuide)
	if hasGuide then
		self:addGuideEffect()
	else
		self:removeGuideEffect()
	end
	return hasGuide
end
function cityBuildDrillGround:addGuideEffect()
	local et_node = self:getChildByName("et_Activity")
	if et_node then
		et_node:setVisible(true)
		return
	end
	_ENV, _ENV = et_node, et_node.setVisible
	_ENV, et_node.plist = true, "et_paimaihangyindao_02.plist"
	;(true).x = 0.861
	et_node.scale, (true).y = true, 0.859
	_ENV, et_node.rotate = true, 10.45
	;(true).x = -67.15
	_ENV, et_node.setVisible[1], et_node.pos, (true).y = et_node, et_node, true, -23.5
	_ENV, et_node.plist = true, "et_paimaihangyindao_02.plist"
	;(true).x = 0.7535
	et_node.scale, (true).y = true, 0.8426
	_ENV, et_node.rotate = true, -12.38
	;(true).x = 91.5
	_ENV, et_node.setVisible[2], et_node.pos, (true).y = et_node, et_node, true, -20.840000000000003
	et_node.plist = "et_paimaihangyindao_01.plist"
	_ENV, et_node.scale = true, 1.3419
	;(true).x = 5.560000000000002
	et_node.setVisible[3], et_node.pos, (true).y = et_node, true, -6.5
	local param = et_node.setVisible
	local et_node = SoraDCreateEffectNode(param)
	et_node:setName("et_Activity")
	et_node:addTo(self, 3)
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
	self.buildIndex = self.buildIndex
	self.buildEntity = self
	self.buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_PROMPT
	SoraDSendMessage(self)
end
function cityBuildDrillGround:removeGuideEffect()
	local et_node = self:getChildByName("et_Activity")
	if et_node then
		et_node:setVisible(false)
		if isRemove then
			et_node:removeFromParent()
		end
	end
	if self:getIsCanSpeedUpFree() then
		return
	elseif self:getIsNeedReqHelp() then
		return
	end
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
	self.buildIndex = self.buildIndex
	self.buildEntity = self
	SoraDSendMessage(self)
end
function cityBuildDrillGround:updateTopTip()
	self:checkGuide()
	self:checkDrillArenaAuction()
end
function cityBuildDrillGround:updateViewAfterReset()
	self:updateTopTip()
end
return cityBuildDrillGround
