local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local geocentricAdventureCtrl = gametop.playertop_:getModule("geocentricAdventureCtrl")
local eventGeocentricAdventureView = class("eventGeocentricAdventureView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventGeocentricAdventureView")
	end
	return target
end)
local PANEL_HEIGHT = 180
local MAX_REFRESH_COUNTS = 30
local CORLOR_GREY = cc.c3b(120, 120, 120)
local CORLOR_NORMAL = cc.c3b(255, 255, 255)
local CORLOR_TITLE_NORMAL = cc.c3b(255, 200, 100)
function eventGeocentricAdventureView:ctor()
	self:initControls()
	self:initScrollView()
	self:initDownPanel()
	if SoraDIsFileExistByKey("geocentricAdventure") then
		_ENV, _UPVALUE1_ = "geocentricAdventure", SoraDIsFileExistByKey("geocentricAdventure")
		;("geocentricAdventure").name = "Common/geocentricAdventure"
		local SoraDIsFileExistByKey("geocentricAdventure")[1], imgArray = "geocentricAdventure", SoraDIsFileExistByKey("geocentricAdventure")
		self:loadImages(imgArray, function()
			self:playFireAnimation()
		end)
	end
end
function eventGeocentricAdventureView:initControls()
	self.fireLeft = SoraDGetChildByName(self, "fireLeft")
	self.textTime = SoraDGetChildByName(self, "Text_time")
	self.fireRight = SoraDGetChildByName(self, "fireRight")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.textTitle = SoraDGetChildByName(self, "Text_title")
	self.panelFake = SoraDGetChildByName(self, "Panel_fake")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.panelGrade = SoraDGetChildByName(self, "Panel_grade")
	self.btnRefresh = SoraDGetChildByName(self, "Button_refresh")
	self.panelTreasure = SoraDGetChildByName(self, "Panel_treasure")
	self.iconRefreshGold = SoraDGetChildByName(self, "icon_refresh_gold")
	self.textRefreshPrice = SoraDGetChildByName(self, "Text_refreshPrice")
	self.scroll = SoraDGetChildByName(self, "Center_Size_ScrollView_content")
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonGoldTop_gold")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_geo")
	self.nodeTitle:setTitle(i18n("Exploration_comment_01"))
	self.textTitle:setString(i18n("Exploration_notice_05"))
	self.btnHelp:addTouchEventListener(handler(self, self.helpButtonClickCallBack))
	self.btnRefresh:addTouchEventListener(handler(self, self.refreshButtonClickCallBack))
	self.buyGrade = 1
	self.markIndex = 1
	self.rightPosY = 0
	self.isRefresh = false
	self.selectIndex = 0
	self.tableSelectedIndex, _ENV, self.tableDownCell, _ENV, self.tableDownSelect, _ENV, self.tableDownLine, _ENV, self.downSelectIndex = self.btnRefresh.addTouchEventListener, self.btnRefresh.addTouchEventListener, self.btnRefresh.addTouchEventListener, self.btnRefresh.addTouchEventListener, self.btnRefresh.addTouchEventListener, self.btnRefresh.addTouchEventListener, self.btnRefresh.addTouchEventListener, self.btnRefresh.addTouchEventListener, 0
	self:cleanTable()
	self.sellInfo = geocentricAdventureCtrl:getSellInfo()
	self.buyInfo = geocentricAdventureCtrl:getHaveBoughtInfo()
	self.refreshLimit, self.costGold = geocentricAdventureCtrl:getRefreshLimitAndCostGold()
	self.textRefreshPrice:setString(self.costGold)
	if 0 < #self.buyInfo then
		if #self.buyInfo < 6 then
			self.buyGrade = #self.buyInfo + 1
		else
			self.buyGrade = #self.buyInfo
			self.downSelectIndex = self.buyInfo[6]
		end
	end
	local geoTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.GEOCENTRIC_ADVENTURE)
	if geoTime then
		self.textTime:beginTime(geoTime.timerNode.timer:getRemainTime())
		self.textTime:setTimeEndListener(function(...)
			self:removeFromParent()
		end)
	end
end
function eventGeocentricAdventureView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_GEOCENTRIC_ADVENTURE_REFRESH", handler(self, self.refreshPages))
	SoraDAddMessage(self, "MESSAGE_GEOCENTRIC_ADVENTURE_BUY_SUCCESS", handler(self, self.refreshPages))
	SoraDAddMessage(self, "MESSAGE_GEOCENTRIC_ADVENTURE_NEXT_DAY_REFRESH", handler(self, self.NextDayRefreshPages))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventGeocentricAdventureView:initScrollView()
	self.scroll:removeAllChildren()
	local scrollH = math.max(#self.sellInfo * PANEL_HEIGHT, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(display.width, scrollH))
	for i = 1, #self.sellInfo - 1 do
		local panel = self.panelGrade:clone()
		panel:addTo(self.scroll, i)
		panel:setPosition(cc.p(display.width / 2, scrollH - (i - 1) * PANEL_HEIGHT))
		local buttonBuy = SoraDGetChildByName(panel, "button_buy")
		local textGrade = SoraDGetChildByName(panel, "Text_grade")
		local imageBgRed = SoraDGetChildByName(panel, "img_bgRed")
		local textNowPrice = SoraDGetChildByName(panel, "Text_nowPrice")
		local textPastPrice = SoraDGetChildByName(panel, "Text_pastPrice")
		local textDiscount = SoraDGetChildByName(panel, "BitmapFontLabel_discount")
		local imageGold = SoraDGetChildByName(panel, "icon_recharge_gold_01_16")
		local particleUp = SoraDGetChildByName(panel, "Particle_up")
		local particleMiddle = SoraDGetChildByName(panel, "Particle_middle")
		local particleDown = SoraDGetChildByName(panel, "Particle_down")
		particleUp:setLocalZOrder(40)
		if self.buyGrade ~= i then
			particleUp:stopSystem()
			particleMiddle:stopSystem()
			particleDown:stopSystem()
		end
		_ENV = cc.p(display.width / 2, scrollH - (i - 1) * PANEL_HEIGHT)
		cc.p(display.width / 2, scrollH - (i - 1) * PANEL_HEIGHT).section = i
		textGrade:setString(i18n("common_text_622", cc.p(display.width / 2, scrollH - (i - 1) * PANEL_HEIGHT)))
		buttonBuy:setTag(i)
		imageBgRed:setTag(i)
		buttonBuy:addTouchEventListener(handler(self, self.buyButtonClickCallBack))
		textNowPrice:setString(self.sellInfo[i][1].gold)
		textPastPrice:setString(self.sellInfo[i][1].origold)
		local discountNum = math.floor((self.sellInfo[i][1].origold - self.sellInfo[i][1].gold) / self.sellInfo[i][1].origold * 100) .. "%"
		textDiscount:setString(discountNum)
		self:addDiscountLine(textPastPrice)
		for j = 1, #self.sellInfo[i] do
			self:createGeoCentricCell(j, self.sellInfo[i][j].sell, panel)
			self.markIndex = self.markIndex + 1
		end
		table.insert(self.tablePanel, panel)
		table.insert(self.tableBgRed, imageBgRed)
		table.insert(self.tableButton, buttonBuy)
		table.insert(self.tableGrade, textGrade)
		table.insert(self.tableGold, imageGold)
	end
	local panelFake = self.panelFake:clone()
	panelFake:addTo(self.scroll, 6)
	panelFake:setPosition(cc.p(display.width / 2, scrollH - 5 * PANEL_HEIGHT))
	self:ScrollViewJumpToRightPos()
	self:setBuyGradeState(self.buyGrade)
end
function eventGeocentricAdventureView:createGeoCentricCell(cellIndex, cellData, father)
	local cell = SoraDCreatePanel("eventGeocentricCell")
	cell:initData(cellData[1], cellData[2])
	cell:setClickDelegate(handler(self, self.singleCellClick))
	cell:sendParentToButton(self)
	cell:setTag(self.markIndex)
	cell:addTo(father, cellIndex + 20)
	local spriteLight = ccui.ImageView:create("frame_goods_01.png", ccui.TextureResType.plistType)
	spriteLight:setScale9Enabled(true)
	spriteLight:setContentSize(cc.size(121, 121))
	spriteLight:addTo(cell, 10)
	spriteLight:setVisible(false)
	local spriteSelect = ccui.ImageView:create("icon_czhl_g.png", ccui.TextureResType.plistType)
	spriteSelect:addTo(cell, 11)
	spriteSelect:setScale(0.7)
	spriteSelect:setTag(self.markIndex)
	if SoraDFIsRA() then
		spriteLight:setPosition(cc.p(-48, -48))
		spriteSelect:setPosition(cc.p(-25, -70))
		cell:setPosition(cc.p(590 - (cellIndex - 1) * 120, 125))
	else
		spriteLight:setPosition(cc.p(50, -48))
		spriteSelect:setPosition(cc.p(70, -70))
		cell:setPosition(cc.p(50 + (cellIndex - 1) * 120, 125))
	end
	if #self.buyInfo > 0 then
		for i = 1, #self.buyInfo do
			if math.ceil(spriteSelect:getTag() / 3) == i then
				spriteSelect:setVisible(spriteSelect:getTag() - (i - 1) * 3 == self.buyInfo[i])
				break
			else
				spriteSelect:setVisible(false)
			end
		end
	else
		spriteSelect:setVisible(false)
	end
	table.insert(self.tableCell, cell)
	table.insert(self.tableLine, spriteLight)
	table.insert(self.tableSelect, spriteSelect)
end
function eventGeocentricAdventureView:setBuyGradeState(buyGrade)
	for i, v in ipairs(self.tableButton) do
		v:setTouchEnabled(buyGrade == i)
		v:setColor(buyGrade == i and CORLOR_NORMAL or CORLOR_GREY)
	end
	for i, v in ipairs(self.tableBgRed) do
		v:setVisible(buyGrade == i)
	end
	for i, v in ipairs(self.tableGrade) do
		v:setColor(buyGrade == i and CORLOR_TITLE_NORMAL or CORLOR_GREY)
	end
	for i, v in ipairs(self.tableGold) do
		v:setColor(buyGrade == i and CORLOR_NORMAL or CORLOR_GREY)
	end
	for i, v in ipairs(self.tableCell) do
		local tag = math.ceil(i / 3)
		v:setButtonEnable(buyGrade == tag)
		v.nodeItem:setColor(buyGrade == tag and CORLOR_NORMAL or CORLOR_GREY)
	end
	if #self.buyInfo > 0 then
		for i, v in ipairs(self.buyInfo) do
			if i < 6 then
				local rightIndex = v + (i - 1) * 3
				self.tableCell[rightIndex].nodeItem:setColor(CORLOR_NORMAL)
			end
		end
	end
	if 0 < #self.tableSelectedIndex then
		for i, v in ipairs(self.tableSelectedIndex) do
			self.tableSelect[v]:setVisible(true)
		end
	end
	if self.downSelectIndex ~= 0 and 0 < #self.tableDownSelect then
		self.tableDownSelect[self.downSelectIndex]:setVisible(true)
	end
	if 0 < #self.tableDownCell then
		for i, v in ipairs(self.tableDownCell) do
			if #self.buyInfo < 6 then
				if 6 <= self.buyGrade then
					v:setButtonEnable(true)
					v.nodeItem:setColor(CORLOR_NORMAL)
				else
					v:setButtonEnable(false)
					v.nodeItem:setColor(CORLOR_GREY)
				end
			else
				v:setButtonEnable(false)
				v.nodeItem:setColor(v:getTag() == self.downSelectIndex and CORLOR_NORMAL or CORLOR_GREY)
			end
			v:setTipsVisible(false)
			v:initData(self.sellInfo[6][i].sell[1], self.sellInfo[6][i].sell[2])
		end
	end
end
function eventGeocentricAdventureView:initDownPanel()
	local downPanel = self.panelTreasure
	downPanel:setPosition(cc.p(320, 0))
	local downText = SoraDGetChildByName(downPanel, "Text_downGrade")
	self.downButton = SoraDGetChildByName(downPanel, "button_downBuy")
	self.downNowPrice = SoraDGetChildByName(downPanel, "Text_downNowPrice")
	self.downPastPrice = SoraDGetChildByName(downPanel, "Text_downPastPrice")
	self.downGoldIcon = SoraDGetChildByName(downPanel, "icon_recharge_gold_01_16")
	self.downGoldIcon:setLocalZOrder(40)
	self.downPastPrice:setLocalZOrder(40)
	self.downNowPrice:setLocalZOrder(40)
	for i = 1, #self.sellInfo[6] do
		local cell = SoraDCreatePanel("eventGeocentricCell")
		cell:initData(self.sellInfo[6][i].sell[1], self.sellInfo[6][i].sell[2])
		cell:setClickDelegate(handler(self, self.singleDownCellClick))
		cell:sendParentToButton(self)
		cell:setTag(i)
		cell:addTo(downPanel)
		if 6 > #self.buyInfo then
			if 6 <= self.buyGrade then
				cell:setButtonEnable(true)
				cell.nodeItem:setColor(CORLOR_NORMAL)
			else
				cell:setButtonEnable(false)
				cell.nodeItem:setColor(CORLOR_GREY)
			end
		else
			cell:setButtonEnable(false)
			cell.nodeItem:setColor(cell:getTag() == self.downSelectIndex and CORLOR_NORMAL or CORLOR_GREY)
		end
		local spriteDownLight = ccui.ImageView:create("frame_goods_01.png", ccui.TextureResType.plistType)
		spriteDownLight:setScale9Enabled(true)
		spriteDownLight:setContentSize(cc.size(121, 121))
		spriteDownLight:addTo(cell, 10)
		spriteDownLight:setVisible(false)
		local spriteDownSelect = ccui.ImageView:create("icon_czhl_g.png", ccui.TextureResType.plistType)
		spriteDownSelect:addTo(cell, 11)
		spriteDownSelect:setTag(i)
		spriteDownSelect:setScale(0.7)
		spriteDownSelect:setVisible(self.downSelectIndex ~= 0 and self.downSelectIndex == spriteDownSelect:getTag())
		if SoraDFIsRA() then
			cell:setPosition(cc.p(250 + (i - 1) * 120, 200))
			spriteDownLight:setPosition(cc.p(-48, -48))
			spriteDownSelect:setPosition(cc.p(-30, -70))
		else
			cell:setPosition(cc.p(150 + (i - 1) * 120, 200))
			spriteDownLight:setPosition(cc.p(50, -48))
			spriteDownSelect:setPosition(cc.p(70, -70))
		end
		table.insert(self.tableDownCell, cell)
		table.insert(self.tableDownSelect, spriteDownSelect)
		table.insert(self.tableDownLine, spriteDownLight)
	end
	downText:setString(i18n("Exploration_comment_04"))
	self.downNowPrice:setString(self.sellInfo[6][1].gold)
	self.downPastPrice:setString(self.sellInfo[6][1].origold)
	self.downButton:addTouchEventListener(handler(self, self.buyDownButtonClickCallBack))
	self:addDiscountLine(self.downPastPrice)
	self:buyLastLimit()
end
function eventGeocentricAdventureView:singleCellClick(pItem)
	for i, v in ipairs(self.tableLine) do
		v:setVisible(pItem:getTag() == i)
		self.selectIndex = pItem:getTag()
	end
end
function eventGeocentricAdventureView:singleDownCellClick(pItem)
	for i, v in ipairs(self.tableDownLine) do
		v:setVisible(pItem:getTag() == i)
		self.downSelectIndex = pItem:getTag()
	end
end
function eventGeocentricAdventureView:helpButtonClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).num = 30
		_ENV = [[
1.%s
 2.%s
 3.%s
 4.%s
 5.%s]]
		;([[
1.%s
 2.%s
 3.%s
 4.%s
 5.%s]]).float = SoraDFLabelR()
		SoraDShowHelpMsgTip(string.format([[
1.%s
 2.%s
 3.%s
 4.%s
 5.%s]], i18n("Exploration_comment_05"), i18n("Exploration_comment_06"), i18n("Exploration_comment_07"), i18n("Exploration_comment_08"), i18n("Exploration_comment_09", nil)), [[
1.%s
 2.%s
 3.%s
 4.%s
 5.%s]])
	end
end
function eventGeocentricAdventureView:refreshButtonClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if lordInfoCtrl:getBaseInfo().gold >= self.costGold then
			if not self.refreshLimit then
				self.textRefreshPrice:setString(self.costGold)
				geocentricAdventureCtrl:sendRefreshMsg()
				self.isRefresh = true
			else
				SoraDShowMsgTip(i18n("Exploration_notice_03"))
			end
		else
			SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_054"), nil, handler(self, self.gotoStore))
		end
	end
end
function eventGeocentricAdventureView:gotoStore(type)
	if type == MSGBOX_CALLBACK_YES then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function eventGeocentricAdventureView:buyButtonClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.selectIndex ~= 0 then
			if lordInfoCtrl:getBaseInfo().gold >= self.sellInfo[self.buyGrade][1].gold then
				_ENV = self.buyGrade
				self.buyGrade.gold = string.formatnumberthousands(self.sellInfo[self.buyGrade][1].gold)
				local str = i18n("Exploration_notice_04", self.buyGrade)
				SoraDShowBuyBox(str, self.sellInfo[self.buyGrade][1].gold, nil, function(callBack)
					if callBack == MSGBOX_CALLBACK_YES then
						geocentricAdventureCtrl:sendBuyMsg(self.selectIndex - (self.buyGrade - 1) * 3)
						table.insert(self.tableSelectedIndex, self.selectIndex)
					end
				end)
			else
				SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_054"), nil, handler(self, self.gotoStore))
			end
		else
			SoraDShowMsgTip(i18n("Exploration_notice_05"))
		end
	end
end
function eventGeocentricAdventureView:buyDownButtonClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("wkerwefhwkjehjk", self.buyGrade)
		if self.buyGrade > 5 then
			if self.downSelectIndex ~= 0 then
				if lordInfoCtrl:getBaseInfo().gold >= self.sellInfo[6][1].gold then
					geocentricAdventureCtrl:sendBuyMsg(self.downSelectIndex)
					self.isRefresh = false
				else
					SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_054"), nil, handler(self, self.gotoStore))
				end
			else
				SoraDShowMsgTip(i18n("Exploration_notice_05"))
			end
		else
			SoraDShowMsgTip(i18n("Exploration_notice_01"))
		end
	end
end
function eventGeocentricAdventureView:cleanTable()
	self.tableSelect, _UPVALUE0_, self.tableGold, _UPVALUE0_, self.tableGrade, _UPVALUE0_, self.tableBgRed, _UPVALUE0_, self.tableButton, _UPVALUE0_, self.tablePanel, _UPVALUE0_, self.tableLine, _UPVALUE0_, self.tableCell, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function eventGeocentricAdventureView:ScrollViewJumpToRightPos()
	local scrollInner = self.scroll:getInnerContainer()
	local scrollInnerNewH = math.max(PANEL_HEIGHT * 6, self.scroll:getContentSize().height)
	self.rightPosY = scrollInnerNewH - PANEL_HEIGHT * self.buyGrade
	if self.rightPosY > 0 and self.buyGrade > 1 then
		local scrollPercent = 100 * (1 - self.rightPosY / scrollInner:getContentSize().height)
		scrollPercent = math.min(100, math.max(0, scrollPercent))
		self.scroll:scrollToPercentVertical(scrollPercent, 0.2, true)
	end
	if self.buyGrade >= 5 then
		self.scroll:jumpToBottom()
	end
end
function eventGeocentricAdventureView:NextDayRefreshPages()
	self.buyGrade = 1
	self.downSelectIndex = 0
	self:refreshPages()
	local geoTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.GEOCENTRIC_ADVENTURE)
	if geoTime then
		self.textTime:beginTime(geoTime.timerNode.timer:getRemainTime())
		self.textTime:setTimeEndListener(function(...)
			self:removeFromParent()
		end)
	end
end
function eventGeocentricAdventureView:refreshPages()
	self.sellInfo = geocentricAdventureCtrl:getSellInfo()
	self.buyInfo = geocentricAdventureCtrl:getHaveBoughtInfo()
	self.refreshLimit, self.costGold = geocentricAdventureCtrl:getRefreshLimitAndCostGold()
	print("kwjgrwkehjrgewhr222", self.buyGrade)
	self.textRefreshPrice:setString(self.costGold)
	if #self.buyInfo > 0 then
		if #self.buyInfo < 6 then
			self.buyGrade = #self.buyInfo + 1
		else
			self.buyGrade = #self.buyInfo
		end
	else
		self.buyGrade = 1
	end
	print("kwjgrwkehjrgewhr1111111", self.buyGrade, self.downSelectIndex)
	self.markIndex = 1
	self:cleanTable()
	self:initScrollView()
	for i, v in ipairs(self.tableDownLine) do
		v:setVisible(false)
	end
	for i, v in ipairs(self.tableDownSelect) do
		v:setVisible(not self.isRefresh and i == self.downSelectIndex)
	end
	self:buyLastLimit()
	if self.buyGrade == 6 and self.downSelectIndex ~= 0 then
		geocentricAdventureCtrl = self.downSelectIndex
		self.downSelectIndex.delay = 2.0
		function self.downSelectIndex.onComplete()
			local panel = SoraDShowMsgBox(i18n("underground_explore_text_01"), i18n("common_text_911"), i18n("common_text_185"), function(exitType)
				if MSGBOX_CALLBACK_YES == exitType then
					if lordInfoCtrl:getBaseInfo().gold >= self.costGold then
						if not self.refreshLimit then
							geocentricAdventureCtrl:sendRefreshMsg()
							self.isRefresh = true
						else
							SoraDShowMsgTip(i18n("Exploration_notice_03"))
						end
					else
						SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_054"), nil, handler(self, self.gotoStore))
					end
				elseif MSGBOX_CALLBACK_NO == exitType then
					_ENV = i18n("common_text_430")
					i18n("common_text_430").msg = "MESSAGE_UI_COMMON_MSGBOX"
					SoraDSendMessage((i18n("common_text_430")))
				end
			end)
			panel:setTextAndGoldOnYesBtn(self.costGold, i18n("common_text_911"))
		end
		transition.execute(self, nil, self.downSelectIndex)
	end
	self.tableSelectedIndex, geocentricAdventureCtrl = transition.execute, transition.execute
	self.selectIndex = 0
	self.downSelectIndex = 0
	if self.buyGrade == 1 then
		self.scroll:jumpToTop()
	end
end
function eventGeocentricAdventureView:buyLastLimit()
	if #self.buyInfo < 6 then
		if 6 <= self.buyGrade then
			self.downNowPrice:setColor(CORLOR_NORMAL)
			self.downPastPrice:setColor(CORLOR_NORMAL)
			self.downButton:setTouchEnabled(true)
			self.downButton:setColor(CORLOR_NORMAL)
			self.downGoldIcon:setColor(CORLOR_NORMAL)
			self:playDownButtonAnimation()
		else
			self.downNowPrice:setColor(CORLOR_GREY)
			self.downPastPrice:setColor(CORLOR_GREY)
			self.downButton:setTouchEnabled(false)
			self.downButton:setColor(CORLOR_GREY)
			self.downGoldIcon:setColor(CORLOR_GREY)
			self:stopDownButtonAnimation()
		end
	else
		self.downNowPrice:setColor(CORLOR_GREY)
		self.downPastPrice:setColor(CORLOR_GREY)
		self.downButton:setTouchEnabled(false)
		self.downButton:setColor(CORLOR_GREY)
		self.downGoldIcon:setColor(CORLOR_GREY)
		self:stopDownButtonAnimation()
	end
end
function eventGeocentricAdventureView:addDiscountLine(target)
	_UPVALUE2_, _UPVALUE2_ = nil, nil
	_UPVALUE2_, (nil)[1] = 2, 2
	_UPVALUE2_, (nil)[2] = 2, 3
	;(2)[1] = 42
	;(2)[2] = 18
	_ENV, (nil)[1] = nil, nil
	_ENV, (nil)[2] = nil, 2
	;(nil).borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0)
	;(nil).borderWidth = 2
	local line = display.newLine(nil, nil)
	line:addTo(target)
end
function eventGeocentricAdventureView:playFireAnimation()
	local frames = display.newFrames("dh_dxtanxian_%02d.png", 1, 12)
	frames[#frames + 1] = cc.SpriteFrameCache:getInstance():getSpriteFrame("dh_dxtanxian_01.png")
	local animation = display.newAnimation(frames, 1 / #frames)
	local animation1 = display.newAnimation(frames, 1 / #frames)
	self.fireLeft:stopAllActions()
	self.fireLeft:playAnimationForever(animation)
	self.fireRight:stopAllActions()
	self.fireRight:playAnimationForever(animation1)
end
function eventGeocentricAdventureView:playDownButtonAnimation()
end
function eventGeocentricAdventureView:stopDownButtonAnimation()
	if self.spark then
		self.spark:setVisible(false)
	end
end
function eventGeocentricAdventureView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.GEOCENTRIC_ADVENTURE) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return eventGeocentricAdventureView
