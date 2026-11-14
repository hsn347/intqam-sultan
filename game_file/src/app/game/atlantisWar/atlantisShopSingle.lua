local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local atlantisShopSingle = class("atlantisShopSingle", function(target)
	return target
end)
function atlantisShopSingle:ctor()
	self.nodeCommonItemAward = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward")
	self.textLeftTime = SoraDGetChildByName(self, "Text_LeftTime")
	self.textLeftTime = SoraDCreateTimerLabel(self, self.textLeftTime)
	self.textDiscout = SoraDGetChildByName(self, "Text_Discout")
	self.btnNormal = SoraDGetChildByName(self, "Button_normal")
	self.btnNormal:setSwallowTouches(false)
	self.btnNormal:addTouchEventListener(handler(self, self.btnNormalClick))
	self.goldNode = SoraDGetChildByName(self, "Node_gold")
	self.textLeftNum = SoraDGetChildByName(self, "Text_title")
	self.textLeftNum = SoraDChangeTextToHtml(self.textLeftNum)
	self.textGold = SoraDGetChildByName(self, "Text_gold")
	self.checkBox = SoraDGetChildByName(self, "CheckBox")
	self.checkBox:setTouchEnabled(true)
	self.checkBox:setSwallowTouches(true)
	self.checkBox:addEventListener(handler(self, self.checkBoxEventCallBack))
end
function atlantisShopSingle:initData(data, otherData)
	self.exchangItemNum = activityExchangeMallCtrl:getPurpleAgateNum()
	self.itemData = data
	if otherData then
		self.view = otherData.view
		self.scroll = otherData.scroll
	end
	self.shopItemID = data.shopItemID
	self.nodeCommonItemAward:setOwnView(self.view)
	self.nodeCommonItemAward:setOwnScroll(self.scroll)
	self.nodeCommonItemAward:initData(data.shopitem, data.shopitemnum)
	self.textGold:setString(string.formatnumberthousands(data.exchangenum))
	self.textGold:setColor(data.exchangenum <= self.exchangItemNum and cc.c3b(255, 255, 0) or cc.c3b(255, 0, 0))
	SoraDToCenter(self.goldNode, 10, SoraDFIsRA())
	local exchangNum = activityExchangeMallCtrl:getExchangeNum(data.activityID, data.shopItemID)
	self.leftExchangeNum = math.max(0, data.limitnum - exchangNum)
	activityExchangeMallCtrl = SoraDFIsRA()
	SoraDFIsRA().member = self.leftExchangeNum
	activityExchangeMallCtrl, activityExchangeMallCtrl, SoraDFIsRA().total = SoraDFIsRA()
	data.limitnum.member, SoraDFIsRA().color = SoraDFIsRA()
	self.textLeftNum:setString(i18n_html("common_text_155", SoraDFIsRA()))
	self.btnNormal:setTouchEnabled(0 < self.leftExchangeNum)
	self.btnNormal:setBright(0 < self.leftExchangeNum)
	self.checkBox:setSelected(activityExchangeMallCtrl:getRemindStatus(data.activityID, data.shopItemID) == 1)
	if data.limitType == 5 then
		self.textLeftTime:beginTime(atlantisActivityCtrl:getRoundEndTime() - serviceFunctions.systemTime())
	else
		self.textLeftTime:beginTime(atlantisActivityCtrl:getActivityEndTime() - serviceFunctions.systemTime())
	end
end
function atlantisShopSingle:btnNormalClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll, eventType) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local needNum = self.itemData.exchangenum
		local maxCount = self.leftExchangeNum
		local canBuyCount = math.floor(self.exchangItemNum / needNum)
		maxCount = math.min(maxCount, canBuyCount)
		if maxCount <= 0 then
			_ENV = nil
			;(nil).item = include("publicRead").getName(self.itemData.exchangeitem)
			SoraDShowMsgTip(i18n("common_text_1806", nil))
			return
		end
		local needNum = self.itemData.exchangenum
		local shopitem = self.itemData.shopitem
		_ENV = i18n("common_text_1806", nil)
		i18n("common_text_1806", nil)[40004060] = true
		i18n("common_text_1806", nil)[40004062] = true
		i18n("common_text_1806", nil)[40004065] = true
		i18n("common_text_1806", nil)[40004066] = true
		i18n("common_text_1806", nil)[40004082] = true
		local i18n("common_text_1806", nil)[40004083], config = true, i18n("common_text_1806", nil)
		local isLimit = config[shopitem] or false
		if isLimit then
			maxCount = 1
		end
		_ENV, _ENV, _ENV = i18n("common_text_1806", nil)
		i18n("common_text_1806", nil).targetID = self.itemData.shopitem
		i18n("common_text_1806", nil).exchangeID = self.itemData.exchangeitem
		i18n("common_text_1806", nil).singCount = needNum
		i18n("common_text_1806", nil).curNum = maxCount
		i18n("common_text_1806", nil).exchangeData, i18n("common_text_1806", nil).huntCount = i18n("common_text_1806", nil)
		i18n("common_text_1806", nil).exchangeCfg, i18n("common_text_1806", nil).exchangeHandler = i18n("common_text_1806", nil)
		i18n("common_text_1806", nil).hideSlider = isLimit
		uiManager:show("newShopSingleBuy", i18n("common_text_1806", nil))
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function atlantisShopSingle:checkExchangeLimit(num)
	local equipmentMgr = include("equipmentMgr")
	local equipDesRead = include("equipDesRead")
	local shopitem = self.itemData.shopitem
	local eid = equipDesRead.getRealEquipIDAndQuality(shopitem)
	local ok, equip = equipmentMgr.getNeckLaceEquipmentHaveBuyEx(eid)
	if ok then
		local equipName = equipDesRead.getName(equip:getEID())
		local remainTime = equip:getEquipmentEndTimeProperty() - serviceFunctions.systemTime()
		_ENV = equip:getEID()
		equip:getEID().item = equipName
		equip:getEID().time = SoraDConvertSecondToString(remainTime)
		local showMsg = i18n("common_text_4649", equip:getEID())
		SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				self:reqActivityExchange(num)
			end
		end)
		return true
	end
end
function atlantisShopSingle:reqActivityExchange(num)
	activityExchangeMallCtrl:reqActivityExchange(self.shopItemID, num)
	SoraDShowLoading(self.view)
end
function atlantisShopSingle:checkBoxEventCallBack(target, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 1)
	elseif eventType == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 0)
	end
end
return atlantisShopSingle
