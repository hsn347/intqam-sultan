local gametop = gModuleMgr.getObject("gametop")
local voiceRoomCtrl = gametop.playertop_:getModule("voiceRoomCtrl")
local voiceChatPwdVerify = class("voiceChatPwdVerify", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("voiceChatPwdVerify")
	end
	return target
end)
function voiceChatPwdVerify:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeTitle:setTitleName(i18n("chat_text_57"))
	self.txtFieldPwd = SoraDGetChildByName(self, "TextField_pwd")
	self.txtFieldPwd = SoraDChangeToEditBox(self.txtFieldPwd)
	self.btnOK = SoraDGetChildByName(self, "Button_ok")
	self.btnOK:setTitleText(i18n("common_text_2065"))
	self.btnOK:addTouchEventListener(handler(self, self.btnOKClick))
end
function voiceChatPwdVerify:setCBhandler(handler)
	self.cbHandler = handler
end
function voiceChatPwdVerify:btnOKClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local pwd = self.txtFieldPwd:getString() or ""
		if not voiceRoomCtrl.checkInputPwd(pwd) then
			_ENV = nil
			;(nil).num = 4
			SoraDShowMsgTip(i18n("chat_text_13", nil))
			self.txtFieldPwd:setString("")
			return
		end
		if self.cbHandler then
			self.cbHandler(pwd)
		end
		self.txtFieldPwd:closeIME()
		self:removeFromParent()
	end
end
return voiceChatPwdVerify
