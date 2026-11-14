local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
local arenaCtrl = SoraDGetCtrl("arenaCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local exchangeSingle = require("fgui.gcomponent.BuildDrillGround.exchangeSingle")
local wrathBeastExchangeSingle = fgui.extension_class(fgui.GComponent, exchangeSingle)
fgui.register_extension("ui://BuildDrillGround/Com_exchangeSingle", wrathBeastExchangeSingle)
function wrathBeastExchangeSingle:onInit()
	wrathBeastExchangeSingle.super.onInit(self)
end
function wrathBeastExchangeSingle:onShow()
	wrathBeastExchangeSingle.super.onShow(self)
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
function wrathBeastExchangeSingle:onCheckBoxCallBack()
	SoraDPlaySound()
	if self.CheckBox_notify:isSelected() then
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 1)
	else
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 0)
	end
end
function wrathBeastExchangeSingle:initExLimits(exLimits)
	local exLimitsLabel = self.fields.exLimitsLabel
	if not exLimitsLabel then
		return
	end
	exLimitsLabel:setVisible(false)
	self.Button_exchange:setVisible(true)
	if not exLimits or not next(exLimits) then
		return
	end
	local limitType, limitValue = exLimits[1], exLimits[2]
	if limitType == 1 then
		local vipInfo = lordInfoCtrl:getVip()
		local vipLv, isVip = vipInfo[1], vipInfo[2]
		if limitValue > vipLv then
			exLimitsLabel:setVisible(true)
			_ENV = nil
			;(nil).num = limitValue
			exLimitsLabel:setString(i18n("god_beast_text_12", nil))
			self.Button_exchange:setVisible(false)
			return
		end
	end
end
return wrathBeastExchangeSingle
