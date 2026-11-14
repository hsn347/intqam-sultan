local newKingFundRead = include("newKingFundRead")
local newKingFundRulePopView = class("newKingFundRulePopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("newKingFundRulePopView")
	end
	return target
end)
function newKingFundRulePopView:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
end
function newKingFundRulePopView:bandWidget()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_oab")
	self.ccs_bg:hideTitle()
	_UPVALUE1_ = "CCS_commonPopBox_oab"
	;("CCS_commonPopBox_oab")[1] = "Text_day_total"
	SoraDGetChildByFullPath(self.Center_Node, "CCS_commonPopBox_oab"):setString(i18n("new_lord_fund_text_16"))
	_UPVALUE1_ = i18n("new_lord_fund_text_16")
	i18n("new_lord_fund_text_16")[1] = "Text_return_rate"
	SoraDGetChildByFullPath(self.Center_Node, i18n("new_lord_fund_text_16")):setString(i18n("new_lord_fund_text_17"))
	_UPVALUE1_ = i18n("new_lord_fund_text_17")
	i18n("new_lord_fund_text_17")[1] = "Node_dayInfo"
	self.Node_dayInfo = SoraDGetChildByFullPath(self.Center_Node, i18n("new_lord_fund_text_17"))
	self.pannel_item = SoraDGetChildByName(self, "pannel_item")
	self.pannel_item:setVisible(false)
	local itemH = self.pannel_item:getContentSize().height
	local itemN = 7
	for i = 1, itemN do
		local item = self:createRecordItem(i)
		item:addTo(self.Node_dayInfo)
		item:setPosition(cc.p(0, -itemH * i))
		item:setVisible(true)
	end
	local sizeH = 86 + itemH * itemN
	self.ccs_bg:setSize(cc.size(self.ccs_bg:getContentSize().width, sizeH))
	self.ccs_bg:setPositionY(self.ccs_bg:getPositionY() - (sizeH - 340))
end
function newKingFundRulePopView:createRecordItem(day)
	local item = self.pannel_item:clone()
	newKingFundRead = nil
	;(nil)[1] = "img_item_bg"
	item.imgBg = SoraDGetChildByFullPath(item, nil)
	if day % 2 == 1 then
		item.imgBg:setVisible(false)
	end
	newKingFundRead = false
	;(false)[1] = "text_day"
	SoraDGetChildByFullPath(item, false):setString(day)
	local ret = newKingFundRead.getReturnRate(day) / 10 .. "%"
	newKingFundRead = "text_day"
	;("text_day")[1] = "text_return"
	SoraDGetChildByFullPath(item, "text_day"):setString(ret)
	return item
end
return newKingFundRulePopView
