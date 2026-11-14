local activityTimeRead = include("activityTimeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_getWay = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001596/Com_getWay", Com_getWay)
function Com_getWay:onInit()
	self.fields.Btn_go:setString(i18n("common_text_477"))
	self.fields.Btn_go:addClickListener(handler(self, self.btnGoClick))
	self:fixChildrenPos()
end
function Com_getWay:onShow()
end
function Com_getWay:initData(data)
	self.id = data.id
	self.index = data.index
	if self.index == 1 or self.index == 2 then
		local classType = activityShowCtrl:getParamClassType(self.id)
		self.fields.icon:setSpriteFrame(activityTimeRead.getActivityIconByID(self.id, classType))
		self.fields.Text_name:setString(i18n(activityTimeRead.getActivityNameByID(self.id, classType)))
		if activityShowCtrl:isActivityOpen(self.id) then
			self.fields.Btn_go:setVisible(true)
			self.fields.Text_status:setVisible(false)
		else
			self.fields.Btn_go:setVisible(false)
			self.fields.Text_status:setVisible(true)
			self.fields.Text_status:setString(i18n("common_text_3639"))
		end
	elseif self.index == 3 then
		self.fields.icon:setSpriteFrame("icon_activity_exchange_01.png")
		self.fields.Text_name:setString(i18n("mail_text_437"))
		self.fields.Btn_go:setVisible(true)
		self.fields.Text_status:setVisible(false)
	end
end
function Com_getWay:btnGoClick()
	SoraDPlaySound()
	if self.index == 1 or self.index == 2 then
		clientEventMgr.singleClickEvent(self.id)
	elseif self.index == 3 then
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).rechargeIDList = self.id
			uiManager:show("rechargeView", nil)
		else
			local panel = SoraDCreatePanel("rechargeView")
			panel:jumpToLimitNodeByList(12, self.id)
			panel:show()
		end
	end
end
return Com_getWay
