local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
local basePanel = require("fgui.base.baseFguiPanel")
local wiseTutorunlockPanel = class("wiseTutorunlockPanel", basePanel)
function wiseTutorunlockPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function wiseTutorunlockPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "WiseTutor"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function wiseTutorunlockPanel:onInit()
	self.fields.btn_close:setString(i18n("common_text_204"))
	self.fields.title:setString(i18n("Battle_Towers_22"))
	self.fields.Usm_Unlock:setCompleteCallback(handler(self, self.showCloseBtn))
	self.fields.Usm_Unlock:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_Unlock:setPrepareCallback(handler(self, self.delayRunAction2))
	self.fields.btn_close:addClickEventListener(handler(self, self.showGiftAndClose))
	self.fields.Particle_1:setAutoCull(false)
	self.fields.Usm_Unlock2:setPrepareCallback(handler(self, self.delayRunAction))
end
function wiseTutorunlockPanel:onShow()
end
function wiseTutorunlockPanel:delayRunAction()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.3333333333333333)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.Usm_Unlock2:play()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.Usm_Unlock2:play()
	end)
	self:runAction(ffa.seq(nil))
end
function wiseTutorunlockPanel:delayRunAction2()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.8166666666666667)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.Usm_Unlock:play()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.Usm_Unlock:play()
	end)
	self:runAction(ffa.seq(nil))
end
function wiseTutorunlockPanel:showCloseBtn()
	self.fields.btn_close:setVisible(true)
end
function wiseTutorunlockPanel:showGiftAndClose()
	if wiseTutorCtrl:getGiftMsgData() then
		wiseTutorCtrl = wiseTutorCtrl
		wiseTutorCtrl.msg = "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
		wiseTutorCtrl.data = wiseTutorCtrl:getGiftMsgData()
		SoraDSendMessage(wiseTutorCtrl)
		wiseTutorCtrl:resetGiftData()
	end
	self:close()
end
return wiseTutorunlockPanel
