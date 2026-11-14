local gametop = gModuleMgr.getObject("gametop")
local ancientReelCtrl = gametop.playertop_:getModule("ancientReelCtrl")
local activityExchangeMallCtrl = gametop.playertop_:getModule("activityExchangeMallCtrl")
local ancientReelMainShopSingle = class("ancientReelMainShopSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("ancientReelMainShopSingle")
	end
	local commonTaskSingle = include("royalSummonsShopSingleCommon")
	target = commonTaskSingle.new(target)
	return target
end)
function ancientReelMainShopSingle:ctor()
	self.CheckBox_notify = SoraDGetChildByName(self, "CheckBox_notify")
	self.CheckBox_notify:addEventListener(handler(self, self.onCheckBoxCallBack))
	self.Text_notify = SoraDGetChildByName(self, "Text_notify")
	self.Text_notify:setString(i18n("exchange_btn_01"))
end
function ancientReelMainShopSingle:initData(data, otherData)
	if otherData then
		self.view = otherData.view
		self.activityID = otherData.activityID
	end
	self.shopItemID = data.shopItemID
	self.exchangeID = data.exchangeID
	data.hasExchangeNum = ancientReelCtrl:getKingTokenNum()
	data.itemId = data.shopitem
	data.exchangeType = gIDType.ANCIENT_REEL_EXCHANGE
	data.buyNum = activityExchangeMallCtrl:getExchangeNum(self.activityID, data.shopItemID)
	local isNotify = activityExchangeMallCtrl:getRemindStatus(self.activityID, data.shopItemID) == 1
	self.CheckBox_notify:setSelected(isNotify)
	self.item:setScale(0.9)
	self:initData_imp(data, otherData)
end
function ancientReelMainShopSingle:onClickOperate()
	if self.itemData and self.itemData.hasExchangeNum < self.itemData.exchangenum then
		SoraDShowMsgTip(i18n("Ancient_reel_text_10"))
	elseif self.canBuyNum == 0 then
		SoraDShowMsgTip(i18n("summoned_text_47"))
	else
		self:showBuyView()
	end
end
function ancientReelMainShopSingle:onBuyItem(data, num)
	print("选择了数量:", num)
	activityExchangeMallCtrl:reqActivityExchange(self.shopItemID, num)
	SoraDShowLoading(self.view)
end
function ancientReelMainShopSingle:onCheckBoxCallBack(button, event)
	if event == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 1)
	elseif event == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 0)
	end
end
return ancientReelMainShopSingle
