local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildMarket = class("cityBuildMarket", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildMarket:ctor()
end
function cityBuildMarket:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgUpdateMarketView))
	SoraDAddMessage(self, "MESSAGE_MARKET_TRADEBOARDRETURN_CLOSE", handler(self, self.msgUpdateMarketGuide))
	SoraDAddMessage(self, "MESSAGE_MARKET_UPDATE_GUIDE", handler(self, self.msgUpdateMarketGuide))
	SoraDAddMessage(self, "MESSAGE_MAINCITY_VIEW_UPDATE_MARKET_AUCTION", handler(self, self.msgUpdateMarketAuction))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_MARKET_VIEW", handler(self, self.msgUpdateMarketView))
end
function cityBuildMarket:loadView()
	self:loadBaseView()
	print("cityBuildMarket:loadView()")
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_112"), i18n("buildDes_name_112")
	i18n("buildDes_name_112").x = 0
	;(nil).pos, i18n("buildDes_name_112").y = i18n("buildDes_name_112"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildMarket:onAfterInitWithBuildCell()
	print("市场拍卖行金币检测---------")
	self:checkMarketAuction()
end
function cityBuildMarket:onAfterReconnected()
end
function cityBuildMarket:checkGuide()
	local hasGuide = self:hasGuide()
	print("hasGuide = ", hasGuide)
	if hasGuide then
		self:addGuideEffect()
	else
		self:removeGuideEffect()
	end
	return hasGuide
end
function cityBuildMarket:hasGuide()
	local gametop = gModuleMgr.getObject("gametop")
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local isGuideNotComplete = guideCtrl:isGuideNotCompleted(gGuideModule.AUCTION)
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local hasGuide = false
	if not isGuideNotComplete or lordInfoCtrl:getSourceKid() > 0 or not activityShowCtrl:isActivityOpen(gActivityTimeActivityID.SALESROOM_ACTIVITY) then
		hasGuide = false
	else
		hasGuide = true
	end
	if self:getState() ~= "idle" then
		hasGuide = false
	end
	return hasGuide
end
function cityBuildMarket:hasAuctionGold()
	local gametop = gModuleMgr.getObject("gametop")
	local salesRoomAgCtrl = gametop.playertop_:getModule("salesRoomAgCtrl")
	local receivedGold = salesRoomAgCtrl:getNotReceiveGold()
	print("receivedGold = ", receivedGold)
	if receivedGold and 0 < receivedGold then
		local gametop = gModuleMgr.getObject("gametop")
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
		local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
		local worldMapDefine = include("worldMapDefine")
		if worldMapDefine:isInWar() or conquestWarCtrl:isPlayerConquestWarMigration() and 0 < lordInfoCtrl:getSourceKid() or not activityShowCtrl:isActivityOpen(gActivityTimeActivityID.SALESROOM_ACTIVITY) then
			return false
		end
		return true
	end
	return false
end
function cityBuildMarket:isCustomIdle()
	local isIdle = true
	if self:hasAuctionGold() then
		isIdle = false
	end
	return isIdle
end
function cityBuildMarket:checkMarketAuction()
	local hasGuide = self:hasGuide()
	if hasGuide then
		print("市场有引导按钮，不显示金币")
		return
	end
	local cityBuildConstDef = include("cityBuildConstDef")
	if self:refreshNewTradeBoardHint() then
		return
	end
	if self:hasAuctionGold() then
		print("有金币------")
		_ENV = "有金币------"
		;("有金币------").msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		;("有金币------").buildIndex = self.buildIndex
		;("有金币------").buildEntity = self
		;("有金币------").buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_GOLD
		SoraDSendMessage("有金币------")
	else
		print("无金币-----")
		if self:getIsCanSpeedUpFree() then
			return
		elseif self:getIsNeedReqHelp() then
			return
		end
		_ENV = self
		self.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		self.buildIndex = self.buildIndex
		self.buildEntity = self
		self.buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_GOLD
		SoraDSendMessage(self)
	end
end
function cityBuildMarket:msgUpdateMarketAuction(target, data)
	self:checkMarketAuction()
end
function cityBuildMarket:msgUpdateMarketGuide(target, data)
	self:checkGuide()
end
function cityBuildMarket:msgUpdateMarketView(target, data)
	self:checkGuide()
	self:checkMarketAuction()
end
function cityBuildMarket:updateTopTip()
	self:checkGuide()
	self:checkMarketAuction()
end
function cityBuildMarket:updateViewAfterReset()
	self:updateTopTip()
end
function cityBuildMarket:addGuideEffect()
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
function cityBuildMarket:removeGuideEffect(isRemove)
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
function cityBuildMarket:refreshNewTradeBoardHint(...)
	local cityBuildConstDef = include("cityBuildConstDef")
	_ENV = "cityBuildConstDef"
	;("cityBuildConstDef").buildIndex = self.buildIndex
	;("cityBuildConstDef").buildEntity = self
	local ("cityBuildConstDef").buildTopTipType, sendData = cityBuildConstDef.topType.TOP_TYPE_PROMPT, "cityBuildConstDef"
	if SoraDGetCtrl("salesRoomAgCtrl"):getHint() then
		sendData.msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		SoraDSendMessage(sendData)
		return true
	else
		sendData.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		SoraDSendMessage(sendData)
	end
end
return cityBuildMarket
