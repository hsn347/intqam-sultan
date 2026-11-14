local heroWarCtrl = SoraDGetCtrl("heroWarCtrl")
local eventHeroWarPopView = class("eventHeroWarPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventHeroWarPopView")
	end
	return target
end)
function eventHeroWarPopView:ctor()
	self:initWidget()
	self:initData()
end
function eventHeroWarPopView:initWidget()
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:showTitle(i18n("herobattle_text_28"))
	self.Text_des:setString(i18n("herobattle_text_25"))
	self.Text_tips:setString(i18n("common_text_2699"))
	self.Button_get:addTouchEventListener(handler(self, self.btnGetClick))
	self.Button_get:setTitleText(i18n("common_text_1146"))
	self.Image_box_1:setTouchEnabled(true)
	self.Image_box_1:addTouchEventListener(handler(self, self.btnBox1Click))
	self.Image_box_2:setTouchEnabled(true)
	self.Image_box_2:addTouchEventListener(handler(self, self.btnBox2Click))
	if SoraDFIsRA() then
		self.Node_box_1:setPositionX(self.Node_box_2:getPositionX())
		self.Node_box_2:setPositionX(-self.Node_box_1:getPositionX())
	else
		_UPVALUE4_ = self.Node_box_2
		self.Node_box_2[1] = self.Image_box_1
		self.Node_box_2[2] = self.Image_box_2
		self.Node_box_2[3] = self.Text_box_easy
		self.Node_box_2[4] = self.Text_box_difficult
		for k, v in pairs(self.Node_box_2) do
			SoraDFTarget(v, 0)
		end
	end
end
function eventHeroWarPopView:initData()
	local data = heroWarCtrl:getKillRewardData()
	self.Text_box_easy:setString("x" .. string.formatnumberthousands(data.receive1))
	if data.receive1 <= 0 then
		self.Text_box_easy:setColor(cc.c3b(190, 30, 30))
	else
		self.Text_box_easy:setColor(cc.c3b(255, 200, 100))
	end
	self.Text_box_difficult:setString("x" .. string.formatnumberthousands(data.receive2))
	if 0 >= data.receive2 then
		self.Text_box_difficult:setColor(cc.c3b(190, 30, 30))
	else
		self.Text_box_difficult:setColor(cc.c3b(255, 200, 100))
	end
	if 0 >= data.receive1 + data.receive2 then
		self.Button_get:setTouchEnabled(false)
	else
		self.Button_get:setTouchEnabled(true)
	end
end
function eventHeroWarPopView:btnGetClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		heroWarCtrl:sendReqReceiveMsg()
		self:removeFromParent()
	end
end
function eventHeroWarPopView:btnBox1Click(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgTip(i18n("herobattle_text_23"))
	end
end
function eventHeroWarPopView:btnBox2Click(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgTip(i18n("herobattle_text_24"))
	end
end
return eventHeroWarPopView
