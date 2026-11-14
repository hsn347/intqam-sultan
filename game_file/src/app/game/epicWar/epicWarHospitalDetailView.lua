local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local epicWarHospitalDetailView = class("epicWarHospitalDetailView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicWarHospitalDetailView")
	end
	return target
end)
function epicWarHospitalDetailView:ctor()
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_name:setString(i18n("epic_war_treatCamp_name"))
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Button_cancel = SoraDGetChildByName(self, "Button_cancel")
	self.Button_cancel:setTitleText(i18n("common_text_185"))
	self.Button_cancel:addTouchEventListener(handler(self, self.btnCancelCallBack))
	self.Button_treat = SoraDGetChildByName(self, "Button_treat")
	self.Button_treat:addTouchEventListener(handler(self, self.btnTreatCallBack))
	self.Text_treat = SoraDGetChildByName(self.Button_treat, "Text_treat")
	self.Text_treat:setString(i18n("common_text_065"))
	self.Node_num = SoraDGetChildByName(self.Button_treat, "Node_num")
	self.Text_num = SoraDGetChildByName(self.Node_num, "Text_num")
end
function epicWarHospitalDetailView:initData(data, pos)
	self.data = data
	self.pos = pos
	self.price = self.data.eventData.eventParam.price
	self.rate = self.data.eventData.eventParam.rate / 10 .. "%"
	self.mithrilCount = epicWarCtrl:getMithrilCount()
	epicWarCtrl = nil
	;(nil).var1 = self.rate
	self.Text_des:setString(i18n("epic_war_treatCamp_desc", nil))
	self.Text_num:setString(self.price)
	self.Text_num:setColor(self.mithrilCount >= self.price and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
	SoraDToCenter(self.Node_num)
end
function epicWarHospitalDetailView:btnCancelCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function epicWarHospitalDetailView:btnTreatCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("治疗")
		if self.mithrilCount >= self.price then
			epicWarCtrl:sendReqTriggerEvent(self.pos)
			self:removeFromParent()
		else
			SoraDShowMsgTip(i18n("tips_silverCoins_noEnough"))
		end
	end
end
return epicWarHospitalDetailView
