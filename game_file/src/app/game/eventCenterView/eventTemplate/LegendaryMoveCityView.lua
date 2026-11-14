local gametop = gModuleMgr.getObject("gametop")
local eventLuckyRechargeCtrl = gametop.playertop_:getModule("eventLuckyRechargeCtrl")
local LegendaryMoveCityView = class("LegendaryMoveCityView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("LegendaryMoveCityView")
	end
	return target
end)
function LegendaryMoveCityView:ctor()
	self.isAddToPopManager = true
	self:bindBtnClose()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeEventClose))
	self.fistIndex = 1
	self:bandWidget()
	self:initData()
end
function LegendaryMoveCityView:bandWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("migrate_text_01"))
	self.Panel_container = SoraDGetChildByName(self, "Panel_container")
	self.Image_title = SoraDGetChildByName(self, "Image_title")
	self.Image_title:loadTexture("bg_title_migration.png", ccui.TextureResType.plistType)
	self.Text_des_1 = SoraDGetChildByName(self, "Text_des_1")
	self.Text_des_2 = SoraDGetChildByName(self, "Text_des_2")
	self.Text_des_3 = SoraDGetChildByName(self, "Text_des_3")
	self.Text_des_4 = SoraDGetChildByName(self, "Text_des_4")
	self.Panel_city = SoraDGetChildByName(self, "Panel_city")
	self.Panel_move = SoraDGetChildByName(self, "Panel_move")
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:addTouchEventListener(handler(self, self.panelTouchCallback))
	self.Panel_touch:setTouchEnabled(true)
	self.Panel_touch:setSwallowTouches(false)
	self.scroll = SoraDGetChildByName(self, "ScrollView_reward")
	self.Text_countdown = SoraDGetChildByName(self, "Text_countdown")
	self.Text_countdown = SoraDCreateTimerLabel(self, self.Text_countdown)
	self.Text_countdown:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local rechargeTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.MOVE_CITY_ACTIVIYT)
	if rechargeTime then
		self.Text_countdown:beginTime(rechargeTime.timerNode.timer:getRemainTime())
		self.Text_countdown:setTimeEndListener(function(...)
			self:removeFromParent()
		end)
	end
	self.Button_question = SoraDGetChildByName(self, "Button_question")
	self.Button_question:addTouchEventListener(function(button, type)
		if type == ccui.TouchEventType.ended then
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.CROSS_KINGDOM_MIGRATION)
		end
	end)
	self.Button_city_1 = SoraDGetChildByName(self, "Button_city_1")
	self.Button_city_1:addTouchEventListener(handler(self, self.btnGotoCallback))
	self.Button_pre = SoraDGetChildByName(self, "Button_pre")
	self.Button_pre:addTouchEventListener(handler(self, self.btnPreCallback))
	self.Button_next = SoraDGetChildByName(self, "Button_next")
	self.Button_next:addTouchEventListener(handler(self, self.btnNextCallback))
	self.Text_des_1:setString(i18n("migrate_text_03"))
	self.Text_des_2:setString(i18n("migrate_text_02"))
	self.Text_des_3:setString(i18n("mail_migrate_title_01"))
	self.Text_des_4:setString(i18n("migrate_text_04"))
	local textWidth = self.Text_des_1:getContentSize().width
	if 240 < textWidth then
		textWidth = 240
		if SoraDGetDefaultLanguage() == "ru" then
			SoraDSetTextWidthHeight(self.Text_des_1, cc.size(textWidth, 40))
		else
			SoraDSetTextWidthHeight(self.Text_des_1, cc.size(textWidth, 60))
		end
	end
	self.Sprite_left = SoraDGetChildByName(self, "Sprite_des1_left")
	self.Sprite_left:setPositionX(self.Text_des_1:getPositionX() - (self.Sprite_left:getContentSize().width / 2 + textWidth / 2 + 10))
	self.Sprite_right = SoraDGetChildByName(self, "Sprite_des1_right")
	self.Sprite_right:setPositionX(self.Text_des_1:getPositionX() + (self.Sprite_right:getContentSize().width / 2 + textWidth / 2 + 10))
end
function LegendaryMoveCityView:initData()
	local gametop = gModuleMgr.getObject("gametop")
	local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local palaceInfoRead = include("palaceInfoRead")
	if not activityShowCtrl:getMoveInList() then
		local _ENV, cityList = activityShowCtrl:getMoveInList(), activityShowCtrl:getMoveInList()
	end
	self.cityCount = #cityList
	self.Button_city_1:setVisible(false)
	for i, kid in ipairs(cityList) do
		local button = self.Button_city_1:clone()
		button:setVisible(true)
		button:addTo(self.Panel_move)
		button:setPositionX(65 + (i - 1) * 145)
		button:getChildByName("Text_kname"):setString("K" .. kid)
		local isFound, kInfo = kingdomCtrl:isFoundKingdomID(kid)
		local icon = palaceInfoRead.getIcon(kInfo and kInfo.palaceModel or 1)
		local palace = display.newSprite("#" .. icon)
		palace:setPosition(cc.p(50, 40))
		palace:setScale(0.7)
		palace:addTo(button)
		button:setTag(kid)
	end
	if #cityList <= 3 then
		self.Panel_touch:setTouchEnabled(false)
		self.Button_pre:setVisible(false)
		self.Button_next:setVisible(false)
	else
		self.Panel_touch:setTouchEnabled(true)
		self.Button_pre:setVisible(false)
	end
	local migrationRewardRead = include("migrationRewardRead")
	if not migrationRewardRead.getReward() then
		local _ENV, rewards = migrationRewardRead.getReward(), migrationRewardRead.getReward()
	end
	local dataCount = #rewards / 2
	if dataCount == 0 then
		return
	end
	local MAX_COLUMN = 4
	local offsetX = 7
	local offsetY = -4
	local SINGLE_WIDTH = 100
	local SINGLE_HEIGHT = 90
	if dataCount <= MAX_COLUMN then
		offsetX = offsetX + (MAX_COLUMN - dataCount) / 2 * SINGLE_WIDTH
		offsetY = SINGLE_HEIGHT
	end
	local sSize2 = self.scroll:getContentSize()
	if dataCount > MAX_COLUMN * 2 then
		sSize2.height = sSize2.height + 50
		self.scroll:setContentSize(sSize2)
	end
	local scrollH = math.ceil(dataCount / MAX_COLUMN) * SINGLE_HEIGHT
	self.scroll:setInnerContainerSize(cc.size(sSize2.width, scrollH))
	local getItemPosition = function(i)
		local column = (i - 1) % MAX_COLUMN + 1
		local row = math.ceil(i / MAX_COLUMN)
		MAX_COLUMN = i / MAX_COLUMN
		;(i / MAX_COLUMN).x = offsetX + (column - 1) * SINGLE_WIDTH
		local (i / MAX_COLUMN).y, position = offsetY + scrollH - (row - 1) * SINGLE_HEIGHT, i / MAX_COLUMN
		return position
	end
	local _ENV, positions = self.scroll, self.scroll
	local MAX_REWARD = 8
	for i = 1, MAX_REWARD do
		local position = getItemPosition(i)
		positions[#positions + 1] = position
	end
	if dataCount == 6 then
		for i = 1, dataCount do
			if i <= 2 then
				positions[i] = clone(positions[i + 1])
			else
				positions[i] = clone(positions[i + 2])
			end
		end
	end
	for i = 1, dataCount do
		local singleItem = include("itemSingleView").new()
		if positions[i] then
			singleItem:setPosition(positions[i])
		else
			singleItem:setPosition(getItemPosition(i))
		end
		singleItem:addTo(self.scroll)
		singleItem:setScale(0.55)
		_ENV, _ENV = getItemPosition(i)
		getItemPosition(i).id = rewards[i * 2 - 1]
		;(0.55).itemData, getItemPosition(i).count = getItemPosition(i)
		singleItem:initData(0.55)
		singleItem:setButtonTag(rewards[i * 2 - 1])
		singleItem:setItemClickCallback(handler(self, self.showDetail))
	end
	if dataCount <= MAX_COLUMN then
		self.Text_des_4:setPositionY(self.Text_des_4:getPositionY() + (sSize2.height - scrollH))
		self.ccs_bg:setSize(cc.size(self.ccs_bg:getContentSize().width, self.ccs_bg:getContentSize().height - (sSize2.height - scrollH)))
		self.ccs_bg:setPositionY(self.ccs_bg:getPositionY() + (sSize2.height - scrollH))
	elseif dataCount > MAX_COLUMN * 2 then
		self.Text_des_4:setPositionY(self.Text_des_4:getPositionY() - 50)
		self.ccs_bg:setSize(cc.size(self.ccs_bg:getContentSize().width, self.ccs_bg:getContentSize().height + 50))
		self.ccs_bg:setPositionY(self.ccs_bg:getPositionY() - 50)
	end
	if dataCount <= MAX_COLUMN * 2 then
		self.scroll:setTouchEnabled(false)
	else
		self.scroll:setTouchEnabled(true)
	end
end
function LegendaryMoveCityView:showDetail(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		button:stopAllActions()
		if self.tips then
			self.tips:removeFromParent()
			self.tips = nil
		end
	elseif type == ccui.TouchEventType.began then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.2)
		;(nil)[2] = cca.callFunc(function()
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(button:getTag())
			local dt = 140
			if not SoraDFIsRA() then
				dt = -140
			end
			self.tips:setPosition(cc.p(320 + dt, display.cy))
			self.tips:addTo(self, 99)
		end)
		;(nil)[3] = cca.callFunc(function()
			self.tips = SoraDCreatePanel("commonItemTips")
			self.tips:initData(button:getTag())
			local dt = 140
			if not SoraDFIsRA() then
				dt = -140
			end
			self.tips:setPosition(cc.p(320 + dt, display.cy))
			self.tips:addTo(self, 99)
		end)
		button:runAction(cca.seq(nil))
	end
end
function LegendaryMoveCityView:btnGotoCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	local checkCanMoveCity = function()
		local gametop = gModuleMgr.getObject("gametop")
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if allianceMgr:isLeader() then
			SoraDShowMsgTip(i18n("migrate_notice_02"))
			return false
		end
		if allianceMgr:hasJoinAlliance() then
			SoraDShowMsgTip(i18n("migrate_notice_03"))
			return false
		end
		return true
	end
	if not checkCanMoveCity() then
		return
	end
	local kid = button:getTag()
	local msgStr = i18n("migrate_notice_01")
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local lordInfo = lordInfoCtrl:getLordInfo()
	if lordInfo and lordInfo.official then
		msgStr = i18n("migrate_notice_04")
	end
	SoraDShowMsgBox(msgStr, i18n("common_text_204"), nil, function(event)
		if event == MSGBOX_CALLBACK_YES then
			if not checkCanMoveCity() then
				return
			end
			SoraDRemoveAllPanelFromManager(self)
			if kid and 0 < kid and kid <= GAME_KINGDOM_ID_ASSIGN.LEGEND.START then
				SoraDGotoWorldMapPoint(cc.p(600, 600), false, kid)
			end
		end
	end)
end
function LegendaryMoveCityView:btnPreCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	if self.isMoving then
		return
	end
	if self.fistIndex == 1 then
		return
	end
	self.fistIndex = math.max(self.fistIndex - 1, 1)
	self:refreshCityButton(true)
end
function LegendaryMoveCityView:btnNextCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	if self.isMoving then
		return
	end
	if self.fistIndex == self.cityCount - 2 then
		return
	end
	self.fistIndex = math.min(self.fistIndex + 1, self.cityCount - 2)
	self:refreshCityButton(false)
end
function LegendaryMoveCityView:refreshCityButton(isRightDir)
	if self.fistIndex < self.cityCount - 2 then
		self.Button_next:setVisible(true)
	else
		self.Button_next:setVisible(false)
	end
	if self.fistIndex > 1 then
		self.Button_pre:setVisible(true)
	else
		self.Button_pre:setVisible(false)
	end
	self.isMoving = true
	local posx = -145
	if isRightDir then
		posx = 145
	end
	_ENV = 0.2
	;(0.2).onComplete = function()
		self.isMoving = false
	end
	transition.execute(self.Panel_move, cca.moveBy(0.2, posx, 0), 0.2)
end
function LegendaryMoveCityView:panelTouchCallback(panel, eventType)
	if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		local touchBeganPoint = panel:getTouchBeganPosition()
		local touchmovePoint = panel:getTouchEndPosition()
		if touchBeganPoint.x - touchmovePoint.x < -30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 100 then
			print("右移")
			self:btnPreCallback(nil, ccui.TouchEventType.ended)
		elseif touchBeganPoint.x - touchmovePoint.x > 30 and math.abs(touchBeganPoint.y - touchmovePoint.y) < 100 then
			print("左移")
			self:btnNextCallback(nil, ccui.TouchEventType.ended)
		end
	end
end
function LegendaryMoveCityView:judgeEventClose(target, redata)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local state = activityShowCtrl:getStateByID(gActivityTimeActivityID.MOVE_CITY_ACTIVIYT)
	if gActivityState.CLOSE == state then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return LegendaryMoveCityView
