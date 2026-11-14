local enjoylottery_ticket = require_data("enjoylottery_ticket", true)
local enjoyLotteryRulePopView = class("enjoyLotteryRulePopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("enjoyLotteryRulePopView")
	end
	return target
end)
function enjoyLotteryRulePopView:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
	self:initData()
end
function enjoyLotteryRulePopView:bandWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_1173"))
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Node_content"
	self.Node_content = SoraDGetChildByFullPath(self.Center_Node, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Sprite_4"
	self.Sprite_4 = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Sprite_5"
	self.Sprite_5 = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Text_des1"
	self.Text_des1 = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Node_single"
	self.Node_single = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
end
function enjoyLotteryRulePopView:initData()
	self.Text_des1:setString(i18n("enjoylottery_text_01"))
	local desHeight = SoraDGetAutoHeightLabel(self.Text_des1, 480)
	self.Sprite_4:setPositionY(self.Text_des1:getPositionY() - desHeight - 20)
	self.Sprite_5:setPositionY(self.Text_des1:getPositionY() - desHeight - 20)
	local totalH = desHeight + 20 + 40 + 45 * (#enjoylottery_ticket.data + 1) + 80
	local offsety = totalH - self.ccs_bg:getSize().height
	self.ccs_bg:setSize(cc.size(self.ccs_bg:getSize().width, self.ccs_bg:getSize().height + offsety))
	self.ccs_bg:setPositionY(self.ccs_bg:getPositionY() - offsety / 2)
	self.Node_content:setPositionY(self.Node_content:getPositionY() + offsety / 2)
	local posy = self.Sprite_5:getPositionY() - 40
	enjoylottery_ticket = offsety / 2
	;(offsety / 2)[1] = "Text_single"
	SoraDGetChildByFullPath(self.Node_single, offsety / 2):setString(i18n("enjoylottery_text_05"))
	enjoylottery_ticket = i18n("enjoylottery_text_05")
	i18n("enjoylottery_text_05")[1] = "Text_num"
	SoraDGetChildByFullPath(self.Node_single, i18n("enjoylottery_text_05")):setString(i18n("enjoylottery_text_06"))
	self.Node_single:setPosition(cc.p(320, posy))
	for i, v in ipairs(enjoylottery_ticket.data) do
		local widget = self.Node_single:clone()
		widget:addTo(self.Node_content)
		local priceStr = paymentManager.getRealPrice(v.pidindex, v.price)
		enjoylottery_ticket = cc.p(320, posy)
		cc.p(320, posy)[1] = "Text_single"
		SoraDGetChildByFullPath(widget, cc.p(320, posy)):setString(priceStr)
		enjoylottery_ticket = priceStr
		priceStr[1] = "Text_num"
		SoraDGetChildByFullPath(widget, priceStr):setString("X" .. v.lottery)
		widget:setPosition(cc.p(320, posy - 45 * i))
	end
end
return enjoyLotteryRulePopView
