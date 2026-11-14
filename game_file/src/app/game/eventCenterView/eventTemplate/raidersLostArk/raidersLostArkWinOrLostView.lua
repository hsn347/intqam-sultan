local raidersLostArkWinOrLostView = class("raidersLostArkWinOrLostView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("raidersLostArkWinOrLostView")
	end
	return target
end)
local raidersLostArkRead = include("raidersLostArkRead")
local publicRead = include("publicRead")
local raidersLostArkCtrl = SoraDGetCtrl("raidersLostArkCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
function raidersLostArkWinOrLostView:ctor()
	self:initControls()
	self:fitDevice()
end
function raidersLostArkWinOrLostView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.Center_Node:setOpacity(0)
	self:setBackGround(0)
	_UPVALUE4_ = nil
	;(nil)[1] = cca.callFunc(function(...)
	end)
	;(nil)[2] = cca.delay(0.3)
	;(nil)[3] = cca.callFunc(function(...)
		SoraDCreatAnimation(self.__cname, self, false)
	end)
	;(nil)[4] = cca.delay(0.3)
	;(nil)[5] = cca.callFunc(function(...)
		self:setBackGround(204.0)
	end)
	;(nil)[6] = cca.callFunc(function(...)
		self:setBackGround(204.0)
	end)
	self:runAction(cca.seq(nil))
	self.Node_explose:setVisible(false)
	SoraDAutoSizeButtonText(self.Button_detail, cc.size(160, 60))
	self.Button_detail:setTitleText(i18n("common_text_504"))
	self.Button_ok:setTitleText(i18n("common_text_204"))
	self.Button_ok:addTouchEventListener(handler(self, self.btnOkClick))
	self.Button_detail:addTouchEventListener(handler(self, self.btnDetailClick))
	self.activityID = gActivityTimeActivityID.RAIDERS_LOST_ARK
	self.Image_contentBg:setVisible(false)
	self.Node_butiao:setVisible(false)
	self.Image_win:setVisible(false)
	self.Node_action:setPositionY(self.Node_action:getPositionY() - 100)
	self:setCloseCallBack(handler(self, self.exitView))
end
function raidersLostArkWinOrLostView:fitDevice(...)
	if math.floor(display.height) == 853 then
		self.Node_test:setPositionY(self.Node_test:getPositionY() - 100)
		self.Panel_shadow:setPositionY(self.Panel_shadow:getPositionY() - 100)
	elseif math.floor(display.height) > 960 then
		self.Center_Node:setPositionY(480)
		dump(self.Node_test:getPositionY(), "self.Node_test:getPositionY()")
		self.Node_test:setPositionY(self.Node_test:getPositionY() + 100)
		self.Panel_shadow:setPositionY(self.Panel_shadow:getPositionY() + 100)
	end
end
function raidersLostArkWinOrLostView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function raidersLostArkWinOrLostView:initData()
	local isWin, keyID = raidersLostArkCtrl:getWinOrLostRelation()
	local reward = raidersLostArkCtrl:getSnatchedRewardList()
	local tipMsg = ""
	self.Node_Effect:setVisible(false)
	if isWin then
		tipMsg = i18n("Martial_arts_text_29")
		self:playSuccessAni()
		if keyID == reward[1].id then
			tipMsg = i18n("Martial_arts_text_27")
			self.Image_key_icon:loadTexture(publicRead.getIcon(keyID), ccui.TextureResType.plistType)
			self.Image_key_icon:setContentSize(cc.size(132, 132))
			self.Image_key_icon:setCascadeOpacityEnabled(true)
			self.Node_Effect:setVisible(true)
		end
	else
		tipMsg = i18n("Martial_arts_text_30")
		self:playFailAni()
	end
	self.Text_tip:setString(tipMsg)
	if keyID ~= reward[1].id then
		local award = include("commonItemAward").new()
		award:setScale(1.0)
		award:setBaseScale(1.0)
		award:setOwnView(self)
		award:initData(reward[1].id, reward[1].count)
		award:setPosition(0, -20)
		if math.floor(display.height) > 960 then
			award:setPositionY(30)
			if not isWin then
				award:setPositionY(60)
				self.Node_test:setPositionY(self.Node_test:getPositionY() + 50)
			end
		elseif math.floor(display.height) == 960 then
			if not isWin then
				award:setPositionY(-100)
			end
		elseif math.floor(display.height) == 853 then
			award:setPositionY(-200)
		end
		award:addTo(self.Center_Node)
		award:setCascadeOpacityEnabled(true)
		self.Image_key_icon:setVisible(false)
	end
end
function raidersLostArkWinOrLostView:playFailAni(args)
	local node
	node = SoraDCreatAnimation("animationKingWarLose", nil, false)
	if node then
		node:setLocalZOrder(-1)
		self.Node_action:addChild(node)
	end
	SoraDPlaySound("innerbuildsound", 106)
	self.Text_tip:setPositionY(self.Text_tip:getPositionY() - 100)
	self.Node_Effect:setPositionY(self.Node_Effect:getPositionY() - 100)
end
function raidersLostArkWinOrLostView:playSuccessAni()
	local spine_win = sp.SkeletonAnimation:create("spine/shengli.skel", "spine/shengli.atlas", 1)
	spine_win:addTo(self.Node_action, -1)
	spine_win:setAnimation(0, "animation", true)
	self.Node_butiao:setVisible(true)
	self.Image_win:setVisible(true)
end
function raidersLostArkWinOrLostView:btnOkClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		local isWin, keyID = raidersLostArkCtrl:getWinOrLostRelation()
		local reward = raidersLostArkCtrl:getSnatchedRewardList()
		if isWin then
			if keyID == reward[1].id then
				local maintainPanel = SoraDSearchPanelFromManagerByName("raidersLostArkSnatchView")
				if maintainPanel then
					maintainPanel:removeFromParent()
				end
			else
				raidersLostArkCtrl:reqRobberyRefresh()
				SoraDShowLoading(self)
			end
		else
			raidersLostArkCtrl:reqRobberyRefresh()
			SoraDShowLoading(self)
		end
		self:removeFromParent()
	end
end
function raidersLostArkWinOrLostView:btnDetailClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		local arenaltCtrl = include("arenaltCtrl")
		local reportData = raidersLostArkCtrl:getBattleReportData()
		local outData = arenaltCtrl.reportReMake(reportData, gArenaBattleType.RAIDER_LOST_ARK)
		local panel = SoraDCreatePanel("mailItemDetailView")
		panel:show()
		panel:hideRightAndLeftBtn()
		panel:initWithData(outData, "key")
		local isWin, keyID = raidersLostArkCtrl:getWinOrLostRelation()
		local reward = raidersLostArkCtrl:getSnatchedRewardList()
		if isWin and keyID == reward[1].id then
			local maintainPanel = SoraDSearchPanelFromManagerByName("raidersLostArkSnatchView")
			if maintainPanel then
				maintainPanel:removeFromParent()
			end
		end
		raidersLostArkCtrl:reqRobberyRefresh()
		SoraDShowLoading(self)
		self:removeFromParent()
	end
end
function raidersLostArkWinOrLostView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function raidersLostArkWinOrLostView:exitView()
	local isWin, keyID = raidersLostArkCtrl:getWinOrLostRelation()
	local reward = raidersLostArkCtrl:getSnatchedRewardList()
	if isWin then
		if keyID == reward[1].id then
			local maintainPanel = SoraDSearchPanelFromManagerByName("raidersLostArkSnatchView")
			if maintainPanel then
				maintainPanel:removeFromParent()
			end
		else
			raidersLostArkCtrl:reqRobberyRefresh()
			SoraDShowLoading(self)
		end
	else
		raidersLostArkCtrl:reqRobberyRefresh()
		SoraDShowLoading(self)
	end
end
return raidersLostArkWinOrLostView
