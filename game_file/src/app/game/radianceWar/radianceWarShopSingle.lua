local gametop = gModuleMgr.getObject("gametop")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local lightShiningCtrl = SoraDGetCtrl("lightShiningCtrl")
local colorRed = cc.c3b(255, 0, 0)
local colorYellow = cc.c3b(254, 255, 1)
local colorBlue = cc.c3b(200, 221, 255)
local radianceWarShopSingle = class("radianceWarShopSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("radianceWarShopSingle")
	end
	local commonTaskSingle = include("royalSummonsShopSingleCommon")
	target = commonTaskSingle.new(target)
	return target
end)
function radianceWarShopSingle:ctor()
	self.textShopItemNum = SoraDGetChildByName(self, "Text_num")
	self.CheckBox_notify = SoraDGetChildByName(self, "CheckBox_notify")
	self.CheckBox_notify:addEventListener(handler(self, self.onCheckBoxCallBack))
	self.Text_notify = SoraDGetChildByName(self, "Text_notify")
	self.Text_notify:setString(i18n("exchange_btn_01"))
end
function radianceWarShopSingle:initData(data, otherData)
	if otherData then
		self.view = otherData.view
		self.activityID = otherData.activityID
		self.tag = otherData.tag
	end
	self.shopItemID = data.shopItemID
	self.classType = data.classType
	self.shopitemnum = data.shopitemnum
	self.textShopItemNum:setString(self.shopitemnum)
	data.hasExchangeNum = radianceActivityCtrl:getExchangeNum(data.exchangeitem)
	data.itemId = data.shopitem
	data.exchangeType = data.exchangeitem
	data.buyNum = activityExchangeMallCtrl:getExchangeNum(self.activityID, data.shopItemID)
	local isNotify = activityExchangeMallCtrl:getRemindStatus(self.activityID, data.shopItemID) == 1
	self.CheckBox_notify:setSelected(isNotify)
	self.item:setScale(0.9)
	self:initData_imp(data, otherData)
	if self.canBuyNum <= 0 then
		self.text_num:setColor(colorRed)
	else
		local isBuffActive = lightShiningCtrl:isXYBuffActive()
		self.text_num:setColor(isBuffActive and self.tag == 1 and colorYellow or colorBlue)
	end
end
function radianceWarShopSingle:onClickOperate()
	if self.itemData and self.itemData.hasExchangeNum < self.itemData.exchangenum then
		SoraDShowMsgTip(i18n(self.classType == 1 and "brightWar_text_108" or "brightWar_text_109"))
	elseif self.canBuyNum <= 0 then
		SoraDShowMsgTip(i18n("summoned_text_47"))
	else
		self:showBuyView()
	end
end
function radianceWarShopSingle:onBuyItem(data, num)
	print("选择了数量:", num)
	activityExchangeMallCtrl:reqActivityExchange(self.shopItemID, num)
	SoraDShowLoading(self.view)
end
function radianceWarShopSingle:onCheckBoxCallBack(button, event)
	if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
		button:setSelected(not button:isSelected())
		print("不在范围内")
		return
	end
	if event == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 1)
	elseif event == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 0)
	end
end
return radianceWarShopSingle
