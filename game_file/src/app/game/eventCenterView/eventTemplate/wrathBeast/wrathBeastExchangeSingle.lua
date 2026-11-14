local exchangeSingle = include("exchangeSingle")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
local arenaCtrl = SoraDGetCtrl("arenaCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local wrathBeastExchangeSingle = class("wrathBeastExchangeSingle", exchangeSingle)
function wrathBeastExchangeSingle:ctor()
	wrathBeastExchangeSingle.super.ctor(self)
end
function wrathBeastExchangeSingle:initData(data, otherData)
	self.activityID = otherData.activityID
	self.scroll = otherData.scroll
	self.view = otherData.view
	self.itemID = data.shopitem
	self.toolID = data.exchangeitem
	self.singleCount = data.exchangenum
	self.shopItemID = data.shopItemID
	local remindStatus = activityExchangeMallCtrl:getRemindStatus(self.activityID, self.shopItemID)
	local isNotify = remindStatus == 1
	self.CheckBox_notify:setSelected(isNotify)
	_UPVALUE2_ = isNotify
	isNotify[1] = data.exchangeitem
	isNotify[2] = data.exchangenum
	self:setBtnFromData(isNotify)
	_UPVALUE2_ = isNotify
	isNotify[1] = data.shopitem
	isNotify[2] = data.shopitemnum
	self:setBtnToData(isNotify)
	local curExchangeNum = activityExchangeMallCtrl:getExchangeNum(self.activityID, self.shopItemID)
	self:setLeftCount(data.limitType, data.limitnum, curExchangeNum)
	self:setBtnExchangeStatus()
	self:initExLimits(data.exLimits)
end
function wrathBeastExchangeSingle:getOwnCount(itemID)
	if itemID == gIDDef.ARENA_VOUCHER then
		return arenaCtrl:getArenaTicketNums()
	elseif itemID == gIDDef.GODBEAST_GEM then
		return wrathBeastCtrl:getActivityData("godBeastGem")
	else
		return backpackCtrl:getItemCount(itemID)
	end
end
function wrathBeastExchangeSingle:exChangeArenaCallback(itemID, exchangeNum)
	activityExchangeMallCtrl:reqActivityExchange(self.shopItemID, exchangeNum)
end
function wrathBeastExchangeSingle:exChangeCallback(exchangeNum)
	activityExchangeMallCtrl:reqActivityExchange(self.shopItemID, exchangeNum)
end
function wrathBeastExchangeSingle:onCheckBoxCallBack(button, event)
	if event == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 1)
	elseif event == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 0)
	end
end
function wrathBeastExchangeSingle:initExLimits(exLimits)
	local exLimitsLabel = self.Panel_touch:getChildByName("exLimitsLabel")
	if exLimitsLabel then
		exLimitsLabel:setVisible(false)
	end
	self.Button_exchange:setVisible(true)
	if not exLimits or not next(exLimits) then
		return
	end
	local limitType, limitValue = exLimits[1], exLimits[2]
	if limitType == 1 then
		local vipInfo = lordInfoCtrl:getVip()
		local vipLv, isVip = vipInfo[1], vipInfo[2]
		if limitValue > vipLv then
			if not exLimitsLabel then
				local x, y = self.Button_exchange:getPosition()
				_ENV = nil
				;(nil).text = ""
				;(nil).size = 22
				;(nil).color = display.COLOR_RED
				;(nil).x = x
				;(nil).y = y
				;(nil).align = cc.TEXT_ALIGNMENT_CENTER
				;(nil).valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER
				;(nil).dimensions = cc.size(160, 70)
				local label = display.newTTFLabel(nil)
				label:addTo(self.Panel_touch)
				label:setName("exLimitsLabel")
				exLimitsLabel = label
			end
			exLimitsLabel:setVisible(true)
			_ENV = label
			label.num = limitValue
			exLimitsLabel:setString(i18n("god_beast_text_12", label))
			self.Button_exchange:setVisible(false)
			return
		end
	end
end
return wrathBeastExchangeSingle
