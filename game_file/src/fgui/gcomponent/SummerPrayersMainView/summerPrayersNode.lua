local publicRead = include("publicRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local constantRead = include("constantRead")
local summerPrayCtrl = SoraDGetCtrl("summerPrayCtrl")
local summerPrayRead = include("summerPrayRead")
local baseComponent = require("fgui.base.baseComponent")
local summerPrayersNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SummerPrayersMainView/summerPrayersNode", summerPrayersNode)
local maxGiftNum = 6
function summerPrayersNode:onInit()
	self.activityID = gActivityTimeActivityID.SUMMER_PRAY_ACTIVITY
	self.scaleNode = 1
	self.itemID = summerPrayCtrl:getItemID()
	self.nowShowIndex = 0
	self.btnPrayTouch = true
	self.maxResetNum = constantRead.getConstValue("SUMMER_PRAY_MAX_RESET_COUNT", 10)
	self.nodeTop = self.fields.Top_Node_T
	self.doorEffectList = SoraDGetChildsArrayByName(self.nodeTop, "Image_door", 6, 1, true)
	self.spNameList = SoraDGetChildsArrayByName(self.nodeTop, "Sprite_Name_", 6, 1, true)
	self.doorButtonList = SoraDGetChildsArrayByName(self.nodeTop, "Button_DoorClick_", 6, 1, true)
	for i, v in ipairs(self.spNameList) do
		self.doorButtonList[i]:addClickListener(handlerEx(self, self.btnDoorClick, i))
		local frameName = string.format("frame_drqf_name%02d_%s.png", i, SoraDFIsRA() and "ar" or "en")
		v:setURL(frameName)
	end
	self.textActivityTime = self.fields.Label_time
	self.btnLookPreAward = self.fields.Button_Look
	self.btnLookPreAward:addClickListener(handler(self, self.btnLookPreAwardClick))
	self.btnLookPreAward:setString(i18n("decrypt_text_03"))
	self.lBarInter = SoraDGetChildByName(self, "Node_Bar")
	self.btnReset = SoraDGetChildByName(self.lBarInter, "Button_Reset")
	self.btnReset:setString(i18n("common_text_4152"))
	self.btnReset:addClickListener(handler(self, self.btnResetClick))
	self.textResetTime = SoraDGetChildByName(self.lBarInter, "Text_ResetTime")
	self.bar = SoraDGetChildByName(self.lBarInter, "bar")
	self.textBF1 = SoraDGetChildByName(self.lBarInter, "BitmapFontLabel_1")
	self.textLuckyNum = SoraDGetChildByName(self.lBarInter, "Text_LuckyNum")
	self.textLuckyNum:setString(i18n("pray_text_07"))
	self.btnBox = self.fields.Button_ItemAward
	self.btnBox:addClickListener(handler(self, self.btnBoxClick))
	self.Image_lv = SoraDGetChildByName(self.btnBox, "Image_lv")
	local Node_Tips = self.fields.Node_Tips
	self.textBoxName = SoraDGetChildByName(Node_Tips, "Text_BoxName")
	self.textTips = SoraDGetChildByName(Node_Tips, "Text_Tips")
	self.btnPrayerFree = self.fields.Button_PrayerFree
	self.btnPrayerFree:addClickListener(handlerEx(self, self.btnPrayerClick, 1))
	self.btnPrayerFree:setString(i18n("pray_text_09"))
	self.btnPrayer = self.fields.Button_Prayer
	self.btnPrayer:addClickListener(handlerEx(self, self.btnPrayerClick, 1))
	local itemIcon = publicRead.getIcon(self.itemID)
	self.btnPrayer:setCostIcon(itemIcon)
	self.btnPrayer:setCostTitle(1)
	_ENV = handlerEx(self, self.btnPrayerClick, 1)
	handlerEx(self, self.btnPrayerClick, 1).num = 1
	self.btnPrayer:setString(i18n("Icefestival2024_text25", handlerEx(self, self.btnPrayerClick, 1)))
	self.btnPrayerTen = self.fields.Button_PrayerTen
	self.btnPrayerTen:addClickListener(handlerEx(self, self.btnPrayerClick, 10))
	self.btnPrayerTen:setCostIcon(itemIcon)
	self.btnPrayerTen:setCostTitle(10)
	_ENV = handlerEx(self, self.btnPrayerClick, 10)
	handlerEx(self, self.btnPrayerClick, 10).num = 10
	self.btnPrayerTen:setString(i18n("Icefestival2024_text25", handlerEx(self, self.btnPrayerClick, 10)))
	self.nodeNum = SoraDGetChildByName(self, "Node_Num")
	self.textNumHave = SoraDGetChildByName(self.nodeNum, "title")
	self.btnAdd = SoraDGetChildByName(self.nodeNum, "Button_Add")
	self.btnAdd:addClickListener(handler(self, self.btnAddClick))
	local icon_score = SoraDGetChildByName(self.nodeNum, "icon")
	icon_score:setURL(itemIcon)
	self.nodeEndTips = SoraDGetChildByName(self, "Center_Node_bg")
	self.textExplain = SoraDGetChildByName(self.nodeEndTips, "Text_Explain")
	self.textExplain:setString(i18n("pray_text_17"))
	self:initActivityTime()
	self:initData()
	if not SoraDFIsRA() then
		self.btnLookPreAward:fixPos()
		self.lBarInter:fixChildrenPos()
		self.bar:fixChildrenPos()
		self.textNumHave:fixPos()
		self.btnAdd:fixPos()
		icon_score:fixPos()
		self.btnPrayerTen:fixPos()
		self.nodeTop:fixChildrenPos()
		SoraDGetChildByName(self, "Image_bg"):fix()
		for __, v in ipairs(self.doorEffectList) do
			v:fix()
		end
		for __, v in ipairs(self.spNameList) do
			v:setRotation(-v:getRotation())
		end
	end
end
function summerPrayersNode:onShow()
end
function summerPrayersNode:onEnterPanel()
	summerPrayCtrl:reqSummerPrayInit()
end
function summerPrayersNode:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.updateItemNums))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.updateViewState))
	SoraDAddMessage(self, "MESSAGE_SUMMER_PRAY_VIEW", handler(self, self.msgCallBack))
end
function summerPrayersNode:initData(target, data)
	SoraDCloseLoading(self)
	self.boxOrder = summerPrayCtrl:getGiftOrder()
	self.haveResetNum = summerPrayCtrl:getResetPrayCount()
	self.luckyNum = summerPrayCtrl:getPrayValue()
	local config = summerPrayRead.getBoxConfigByOrder(self.boxOrder + 1)
	self.maxLuckyNum = tonumber(config.praypoint)
	self.textBoxName:setString(i18n(publicRead.getName(config.packreward1[1].id)))
	self.btnBox:setIcon(publicRead.getIcon(config.packreward1[1].id))
	local imageName = string.format("icon_army_level_%s%d.png", SoraDFIsRA() and "" or "Roman_", config.packorder)
	self.Image_lv:setURL(imageName)
	self.boxItemID = config.packreward1[1].id
	self.boxItemCount = config.packreward1[1].count
	self:updateItemNums()
	self:updateLoadBar()
	_ENV = publicRead.getIcon(config.packreward1[1].id)
	publicRead.getIcon(config.packreward1[1].id).activityID = self.activityID
	self:updateViewState(nil, publicRead.getIcon(config.packreward1[1].id))
	if summerPrayCtrl:getIsFirst() then
		if summerPrayRead.getActivityType() == 1 then
			self.textTips:setString(i18n("pray_text_24"))
		else
			self.textTips:setString(i18n("Icefestival2024_text10"))
		end
		self.btnPrayer:setVisible(false)
		self.btnPrayerTen:setVisible(false)
		self.btnPrayerFree:setVisible(true)
	else
		self.btnPrayer:setVisible(true)
		self.btnPrayerTen:setVisible(true)
		self.btnPrayerFree:setVisible(false)
		if self.itemNums >= 10 then
			self.btnPrayerTen:setVisible(true)
			if SoraDFIsRA() then
				self.btnPrayer:setPositionX((self:getWidth() - 640) / 2 + 371)
			else
				self.btnPrayer:setPositionX((self:getWidth() - 640) / 2 + 62)
			end
		else
			self.btnPrayer:setPositionX(self.btnPrayerFree:getPositionX())
			self.btnPrayerTen:setVisible(false)
		end
		_ENV = self.btnPrayerFree:getPositionX()
		self.btnPrayerFree:getPositionX().num = config.praypoint
		self.textTips:setString(i18n("pray_text_06", self.btnPrayerFree:getPositionX()))
	end
end
function summerPrayersNode:initActivityTime()
	self.textActivityTime:initActivityTimeStyle(self.activityID, "pray_text_21")
end
function summerPrayersNode:updateItemNums()
	self.itemNums = backpackCtrl:getItemCount(self.itemID)
	self.textNumHave:setString(i18n("palace_text_19") .. self.itemNums)
end
function summerPrayersNode:updateLoadBar()
	local percent = self.luckyNum / self.maxLuckyNum
	self.textBF1:setString(self.luckyNum)
	self.bar:setPercent(percent)
	_ENV = nil
	;(nil).count = self.maxResetNum - self.haveResetNum
	self.textResetTime:setString(i18n("exchange_columntext_01", nil))
	self.textResetTime:setColor(self.maxResetNum == self.haveResetNum and cc.c3b(255, 0, 0) or cc.c3b(255, 255, 255))
	for i, v in ipairs(self.spNameList) do
		v:setGrayed(i > self.boxOrder)
		self.doorEffectList[i]:setVisible(i <= self.boxOrder)
	end
end
function summerPrayersNode:btnLookPreAwardClick()
	SoraDPlaySound()
	local panel = SoraDCreatePanel("summerPrayersPreAwardView")
	panel:show()
end
function summerPrayersNode:btnResetClick()
	SoraDPlaySound()
	if self.haveResetNum == self.maxResetNum and self.boxOrder ~= maxGiftNum then
		SoraDShowMsgTip(i18n("pray_text_19"))
	else
		local msgKey = ""
		if summerPrayRead.getActivityType() == 1 then
			msgKey = i18n("pray_text_18")
		else
			msgKey = i18n("Icefestival2024_text14")
		end
		SoraDShowMsgBox(msgKey, i18n("common_text_204"), nil, function(type)
			if MSGBOX_CALLBACK_YES == type then
				if tolua.isnull(self) then
					return
				end
				self:resetPray()
			end
		end)
	end
end
function summerPrayersNode:btnBoxClick(...)
	print("==summerPrayersNode:btnBoxClick==", self.boxItemID, self.boxItemCount)
	SoraDPlaySound()
	_ENV = "==summerPrayersNode:btnBoxClick=="
	;("==summerPrayersNode:btnBoxClick==").msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	;("==summerPrayersNode:btnBoxClick==").id = self.boxItemID
	;("==summerPrayersNode:btnBoxClick==").num = self.boxItemCount
	;("==summerPrayersNode:btnBoxClick==").pos = cc.p(0, 0)
	SoraDSendMessage("==summerPrayersNode:btnBoxClick==")
end
function summerPrayersNode:resetPray()
	summerPrayCtrl:reqSummerPrayReset()
end
function summerPrayersNode:btnPrayerClick(num)
	SoraDPlaySound()
	print("lth--------btnPrayerClick")
	if not self.btnPrayTouch then
		return
	end
	if self.itemNums <= 0 and not summerPrayCtrl:getIsFirst() then
		local msgKey = ""
		if summerPrayRead.getActivityType() == 1 then
			msgKey = i18n("pray_text_15")
		else
			msgKey = i18n("Icefestival2024_text12")
		end
		SoraDShowMsgBox(msgKey, i18n("common_text_204"), nil, handler(self, self.openShopView))
	elseif self.boxOrder == maxGiftNum then
		local panel = SoraDCreatePanel("summerPrayersPopReset")
		_ENV = nil
		;(nil).yes = i18n("common_text_204")
		;(nil).tips = i18n("pray_text_20")
		;(nil).view = self
		panel:initData(nil, nil)
		panel:show()
	else
		self.btnPrayTouch = false
		if num == 1 then
			summerPrayCtrl:reqSummerPrayBless()
		else
			summerPrayCtrl:reqSummerPrayBlessTen()
		end
	end
end
function summerPrayersNode:btnAddClick()
	SoraDPlaySound()
	self:openShopView(MSGBOX_CALLBACK_YES)
end
function summerPrayersNode:btnDoorClick(index, target, eventType)
	SoraDPlaySound()
	local panel = SoraDCreatePanel("summerPrayersDoorClickView")
	panel:initData(index)
	panel:show()
end
function summerPrayersNode:openShopView(type)
	if MSGBOX_CALLBACK_YES == type then
		uiManager:show("summerPrayersShop")
	end
end
function summerPrayersNode:msgCallBack(target, data)
	if data.subMsg == "bless" then
		print("lth--------blessBack")
		local panel
		if not data.isTen then
			if data.success then
				panel = SoraDCreatePanel("summerPrayersSuccessView")
				self.nowShowIndex = self.boxOrder + 1
				if data.reward then
					_ENV = nil
					;(nil).packreward = data.reward
					;(nil).successItem = data.successItem
					panel:initData(nil)
					panel:panelScaleAct()
					panel:show()
				end
			else
				SoraDShowMsgTip(i18n("pray_text_16"))
				SoraDMailGainItems(data.reward, true)
				self:initData()
			end
		else
			dump(data.reward, "reward")
			if data.success then
				panel = SoraDCreatePanel("summerPrayersSuccessView")
				panel:initTenData(data.reward)
				panel:panelScaleAct()
				panel:show()
			else
				SoraDShowMsgTip(i18n("pray_text_16"))
				SoraDMailGainItems(data.reward, true)
				self:initData()
			end
		end
		_UPVALUE1_ = i18n("pray_text_16")
		i18n("pray_text_16")[1] = ffa.delay(1)
		i18n("pray_text_16")[2] = ffa.callFunc(function()
			self.btnPrayTouch = true
		end)
		i18n("pray_text_16")[3] = ffa.callFunc(function()
			self.btnPrayTouch = true
		end)
		self:runAction(ffa.seq(i18n("pray_text_16")))
	else
		SoraDCloseLoading(self.parentView)
		self:initData()
	end
end
function summerPrayersNode:updateViewState(target, data)
	if data.activityID == self.activityID then
		local activityData = activityShowCtrl:getActivityData(self.activityID)
		self.showEffect = (activityData.doStage or 0) == 0
		self.controllers.c_stage:setSelectedIndex(self.showEffect and 0 or 1)
	end
end
function summerPrayersNode:getEffectNode(...)
	return self.fields.Node_TaiziEffect
end
return summerPrayersNode
