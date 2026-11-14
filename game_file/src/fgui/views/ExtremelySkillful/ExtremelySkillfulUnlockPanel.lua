local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ExtremelySkillfulUnlockPanel = class("ExtremelySkillfulUnlockPanel", baseFguiPanel)
function ExtremelySkillfulUnlockPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ExtremelySkillfulUnlockPanel:ctor", self.viewName)
end
function ExtremelySkillfulUnlockPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ExtremelySkillfulUnlockPanel:onInit()
	print("=======ExtremelySkillfulUnlockPanel:onInit")
	self.fields.btn_close:setString(i18n("common_text_204"))
	self.fields.title:setString(i18n(self.proxy.param.title))
	self.fields.btn_close:addClickEventListener(handler(self, self.showGiftAndClose))
	self.fields.Particle_1:setAutoCull(false)
end
function ExtremelySkillfulUnlockPanel:onShow()
	print("=======ExtremelySkillfulUnlockPanel:onShow")
end
function ExtremelySkillfulUnlockPanel:showGiftAndClose()
	if ExtremelySkillfulCtrl:getGiftMsgData() then
		ExtremelySkillfulCtrl = ExtremelySkillfulCtrl
		ExtremelySkillfulCtrl.msg = "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
		ExtremelySkillfulCtrl.data = ExtremelySkillfulCtrl:getGiftMsgData()
		SoraDSendMessage(ExtremelySkillfulCtrl)
		ExtremelySkillfulCtrl:resetGiftData()
	end
	self:close()
end
return ExtremelySkillfulUnlockPanel
