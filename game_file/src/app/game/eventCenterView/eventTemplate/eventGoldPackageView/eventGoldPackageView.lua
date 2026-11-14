local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local goldPackageCtrl = gametop.playertop_:getModule("goldPackageCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local eventGoldPackageView = class("eventGoldPackageView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventGoldPackageView")
	end
	return target
end)
local CORLOR_WHITE = cc.c3b(255, 255, 255)
local CORLOR_RED = cc.c3b(255, 0, 0)
_ENV = 255
;(255)[gQualityDef.WHITE] = cc.c3b(255, 255, 255)
;(255)[gQualityDef.GREEN] = cc.c3b(0, 190, 30)
;(255)[gQualityDef.BLUE] = cc.c3b(74, 198, 255)
;(255)[gQualityDef.PURPLE] = cc.c3b(217, 67, 255)
;(255)[gQualityDef.ORANGE] = cc.c3b(255, 228, 0)
local (255)[gQualityDef.GOLD], txtShowItemColor = cc.c3b(255, 144, 0), 255
function eventGoldPackageView:ctor()
	self:initControls()
end
function eventGoldPackageView:initControls()
	self.txtTime = SoraDGetChildByName(self, "text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtRemain = SoraDGetChildByName(self, "text_remain")
	self.btnQuest = SoraDGetChildByName(self, "btn_quest_gold")
	self.btnBuy = SoraDGetChildByName(self, "btn_buy")
	self.cellScroll = SoraDGetChildByName(self, "scrollview_item")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_content")
	self.panelSingle = SoraDGetChildByName(self, "panel_single")
	self.nodeGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_gold")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.icon = SoraDGetChildByName(self, "image_icon")
	self.icon:addTouchEventListener(handler(self, self.bigItemClickCallBack))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	SoraDGetChildByName(self, "image_singleBg"):setFillType(1)
	self.txtRemain:setString(i18n("common_text_3173"))
	self.nodeTitle:setTitle(i18n("gold_gift_text_01"))
	self.btnQuest:addTouchEventListener(handler(self, self.questClickCallBack))
	self.btnBuy:addTouchEventListener(handler(self, self.BuyClickCallBack))
	local packageTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.GOLD_PACKAGE)
	if packageTime then
		self.txtTime:beginTime(packageTime.timerNode.timer:getRemainTime())
		self.txtTime:setTimeEndListener(function(...)
			self:removeFromParent()
		end)
	end
	self.remainTimeTable, _ENV = self.txtTime.setTimeEndListener, self.txtTime.setTimeEndListener
	goldPackageCtrl:sendGiftInfoMsg()
	SoraDShowLoading(self)
end
function eventGoldPackageView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_GOLD_PACKAGE_INIT_INFO", function(target, data)
		SoraDCloseLoading(self)
		self:initScroll()
	end)
	SoraDAddMessage(self, "MESSAGE_GOLD_PACKAGE_REFRESH_PACKAGE", handler(self, self.refreshData))
end
function eventGoldPackageView:refreshData(target, data)
	self:initScroll()
end
function eventGoldPackageView:initScroll()
	self.remainTimeTable, goldPackageCtrl = nil, nil
	local packageData = goldPackageCtrl:getPackageInfo()
	self.scroll:removeAllChildren()
	local scrollH = math.max(self.scroll:getContentSize().height, 250 * #packageData)
	self.scroll:setInnerContainerSize(cc.size(display.width, scrollH))
	for i = 1, #packageData do
		local cell = self.panelSingle:clone()
		cell:addTo(self.scroll)
		cell:setPosition(cc.p(display.width / 2, scrollH - 250 * (i - 1)))
		local cellScroll = SoraDGetChildByName(cell, "scrollview_item")
		local txtOri = SoraDGetChildByName(cell, "text_ori")
		local txtNow = SoraDGetChildByName(cell, "text_now")
		local imageIcon = SoraDGetChildByName(cell, "image_icon")
		local txtShow = SoraDGetChildByName(cell, "text_reward")
		local txtNum = SoraDGetChildByName(cell, "text_small")
		local txtLimit = SoraDGetChildByName(cell, "text_limit")
		local txtTime = SoraDGetChildByName(cell, "text_time")
		local imageNew = SoraDGetChildByName(cell, "sprite_hot")
		local imageNameFrame = SoraDGetChildByName(cell, "Image_11")
		txtOri:setString(string.formatnumberthousands(packageData[i].defaultPrice))
		txtNow:setString(string.formatnumberthousands(packageData[i].discountPrice))
		imageIcon:loadTexture(publicRead.getIcon(packageData[i].showItemID), ccui.TextureResType.plistType)
		imageIcon:setTag(packageData[i].showItemID)
		local quality = publicRead.getQuality(packageData[i].showItemID) or 1
		txtShow:setString(publicRead.getName(packageData[i].showItemID))
		txtShow:setColor(txtShowItemColor[quality])
		if txtShow:getContentSize().width > 200 then
			SoraDSetTextWidthHeight(txtShow, cc.size(150, 50))
			imageNameFrame:setContentSize(cc.size(163, 40))
		end
		txtNum:setString(packageData[i].showItemNum)
		local str = string.format("%s%d/%d", i18n("Secret_explore_text_52"), packageData[i].remainTimes, packageData[i].times)
		txtLimit:setString(str)
		txtLimit:setColor(packageData[i].remainTimes > 0 and CORLOR_WHITE or CORLOR_RED)
		txtTime = SoraDCreateTimerLabel(self, txtTime)
		txtTime:setTimeEndListener(handler(self, self.timeEndListener))
		txtTime:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("common_text_607", nil)
		end)
		txtTime:beginTime(packageData[i].endTime - serviceFunctions.systemTime())
		self:initCellScroll(cellScroll, packageData[i].rewardItems)
		local cellBuy = SoraDGetChildByName(cell, "btn_buy")
		cellBuy:setTag(packageData[i].id)
		if not self.remainTimeTable[packageData[i].id] then
			self.remainTimeTable[packageData[i].id], goldPackageCtrl = packageData[i].id, packageData[i].id
			self.remainTimeTable[packageData[i].id] = packageData[i].remainTimes
		end
	end
end
function eventGoldPackageView:initCellScroll(myDarling, smallData)
	myDarling:removeAllChildren()
	local scrollW = math.max(myDarling:getContentSize().width, 85 * #smallData)
	myDarling:setInnerContainerSize(cc.size(scrollW - 10, myDarling:getContentSize().height))
	myDarling:setBounceEnabled(false)
	myDarling:setSwallowTouches(false)
	for i = 1, #smallData do
		local cellSingle = SoraDCreatePanel("eventGeocentricCell")
		cellSingle:initData(smallData[i].id, smallData[i].num)
		cellSingle:setScale(0.75)
		cellSingle:setClickDelegate(handler(self, self.singleCellClick))
		cellSingle:sendParentToButton(self)
		cellSingle:setPosition(cc.p(85 * (i - 1) + 2, myDarling:getContentSize().height - 3))
		cellSingle:addTo(myDarling)
	end
end
function eventGoldPackageView:bigItemClickCallBack(button, type)
	if type == ccui.TouchEventType.ended or type == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		if self.pFloor then
			self.pFloor:removeFromParent()
			self.pFloor = nil
		end
	elseif type == ccui.TouchEventType.began and not self.pFloor then
		local pos = self:convertToNodeSpace(button:getTouchBeganPosition())
		self:openItem(pos, button:getTag())
	end
end
function eventGoldPackageView:openItem(pos, tag)
	self.pFloor = SoraDCreatePanel("commonItemTips")
	self.pFloor:initData(tag)
	if pos.x > 360 then
		self.pFloor:setPosition(pos.x - 280, pos.y + 40)
	else
		self.pFloor:setPosition(pos.x, pos.y + 40)
	end
	self.pFloor:addTo(self, 100)
end
function eventGoldPackageView:singleCellClick(pItem)
end
function eventGoldPackageView:timeEndListener()
	print("时间到了！")
end
function eventGoldPackageView:questClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("gold_gift_text_02"))
	end
end
function eventGoldPackageView:BuyClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local defaultPrice = 0
		local remainTimes = 0
		local index = button:getTag()
		local packageData = goldPackageCtrl:getPackageInfo()
		for k, v in pairs(self.remainTimeTable) do
			if k == index then
				remainTimes = v
			end
		end
		for k, v in pairs(packageData) do
			if v.id == index then
				defaultPrice = v.discountPrice
			end
		end
		if remainTimes <= 0 then
			SoraDShowMsgTip(i18n("gold_gift_notice_02"))
			return
		end
		if defaultPrice <= lordInfoCtrl:getBaseInfo().gold then
			_ENV = i18n("gold_gift_notice_02")
			i18n("gold_gift_notice_02").item = ""
			SoraDShowMsgBox(i18n("common_text_662", i18n("gold_gift_notice_02")), i18n("common_text_204"), i18n("common_text_185"), function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					goldPackageCtrl:sendBuyPackageMsg(index)
				end
			end)
		else
			SoraDShowMsgBox(i18n("common_text_430"), i18n("common_text_054"), nil, handler(self, self.gotoStore))
		end
	end
end
function eventGoldPackageView:gotoStore(type)
	if type == MSGBOX_CALLBACK_YES then
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
function eventGoldPackageView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.GOLD_PACKAGE) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return eventGoldPackageView
