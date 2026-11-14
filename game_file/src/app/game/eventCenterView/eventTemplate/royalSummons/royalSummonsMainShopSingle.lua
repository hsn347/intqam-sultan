local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsMainShopSingle = class("royalSummonsMainShopSingle", function(target)
	if target == nil then
		if royalSummonsCtrl:getClassType() == 1 then
			target = SoraDCreateBasePanel("royalSummonsMainShopSingle")
		else
			target = SoraDCreateBasePanel("dashToSkyShopSingle")
		end
	end
	local commonTaskSingle = include("royalSummonsShopSingleCommon")
	target = commonTaskSingle.new(target)
	return target
end)
function royalSummonsMainShopSingle:ctor()
	self.CheckBox_notify = SoraDGetChildByName(self, "CheckBox_notify")
	self.CheckBox_notify:addEventListener(handler(self, self.onCheckBoxCallBack))
	self.Text_notify = SoraDGetChildByName(self, "Text_notify")
	self.Text_notify:setString(i18n("exchange_btn_01"))
end
function royalSummonsMainShopSingle:initData(data, otherData)
	if otherData then
		self.view = otherData.view
	end
	self.exchangeID = data.exchangeID
	data.hasExchangeNum = royalSummonsCtrl:getKingTokenNum()
	data.itemId = data.shopitem
	data.exchangeType = gIDType.ROYAL_SUMMONS_EXCHANGE
	data.buyNum = royalSummonsCtrl:getExchangeNum(data.exchangeID)
	local isNotify = royalSummonsCtrl:isExchangeNotity(data.exchangeID)
	self.CheckBox_notify:setSelected(isNotify)
	self.item:setScale(0.9)
	self:initData_imp(data, otherData)
end
function royalSummonsMainShopSingle:onClickOperate()
	if self.itemData and self.itemData.hasExchangeNum < self.itemData.exchangenum then
		SoraDShowMsgTip(i18n(royalSummonsCtrl:getClassType() == 1 and "summoned_text_46" or "summoned_text_67"))
	elseif self.canBuyNum == 0 then
		SoraDShowMsgTip(i18n("summoned_text_47"))
	else
		self:showBuyView()
	end
end
function royalSummonsMainShopSingle:onBuyItem(data, num)
	print("选择了数量:", num)
	royalSummonsCtrl:reqActivityExchange(data.exchangeID, num)
	SoraDShowLoading(self.view)
end
function royalSummonsMainShopSingle:onCheckBoxCallBack(button, event)
	if event == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		royalSummonsCtrl:setExchangeNotity(self.exchangeID, 1)
	elseif event == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		royalSummonsCtrl:setExchangeNotity(self.exchangeID, 0)
	end
end
return royalSummonsMainShopSingle
