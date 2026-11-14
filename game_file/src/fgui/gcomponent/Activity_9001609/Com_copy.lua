local gameInviteltCtrl = include("gameInviteltCtrl")
local accountExtCtrl = SoraDGetCtrl("accountExtCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_copy = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001609/Com_copy", Com_copy)
function Com_copy:onInit()
	self.fields.Button_copy:setString(i18n("common_text_078"))
	self.fields.Button_copy:addClickListener(handler(self, self.btnCopyClick))
	self.pid = accountExtCtrl:getAccountPid()
	_ENV = handler(self, self.btnCopyClick)
	_ENV, _ENV, handler(self, self.btnCopyClick).code = handler(self, self.btnCopyClick)
	self.pid.__default, handler(self, self.btnCopyClick).u = handler(self, self.btnCopyClick)
	self.fields.Text_mineCode:setString(i18n_html("invite_text_10", handler(self, self.btnCopyClick)))
	local methoList = gameInviteltCtrl.getPlatformByVersion()
	for i, v in ipairs(methoList) do
		local target = self.fields["Button_platform" .. i]
		if target then
			target:setString(v.title)
			target:getController("c1"):setSelectedIndex(i - 1)
			target:addClickListener(handlerEx(self, self.btnPlatformClick, v.id))
		end
	end
end
function Com_copy:onShow()
end
function Com_copy:btnPlatformClick(btnID)
	SoraDPlaySound()
	if gGameInvitePlatform.FACEBOOK == btnID then
		self:shareToFaceBook()
	elseif gGameInvitePlatform.WHATSAPP == btnID then
		self:shareToWhatsapp()
	end
end
function Com_copy:getShareContentText(cid)
	local invCode = self.pid
	_ENV = nil
	;(nil).code = invCode
	;(nil).url = SoraGetGameShareUrl("invite", cid)
	return i18n("invite_text_08", nil)
end
function Com_copy:shareToFaceBook()
	local url = SoraGetGameShareUrl("invite", gGameInvitePlatform.FACEBOOK)
	userSDKManager.shareFacebookLinkContent(url)
end
function Com_copy:shareToWhatsapp()
	local invCode = self.pid
	if device.platform == "android" then
		local javaClassName = "org/cocos2dx/lua/AchievementModule"
		local javaMethodName = "sendWhatsApp"
		_ENV = nil
		;(nil)[1] = self:getShareContentText(2)
		;(nil)[2] = self:getShareContentText(2)
		;(nil)[3] = self:getShareContentText(2)
		;(nil)[4] = self:getShareContentText(2)
		;(nil)[5] = self:getShareContentText(2)
		local (nil)[6], javaParams = self:getShareContentText(2)
		local javaMethodSig = "(Ljava/lang/String;)V"
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
	elseif device.platform == "ios" then
		_ENV = device.platform
		local device.platform.contentText, args = self:getShareContentText(2), device.platform
		local ok, ret = luaoc.callStaticMethod("NCSGameCenter", "sendWhatsApp", args)
	end
end
function Com_copy:btnCopyClick()
	SoraDPlaySound()
	SoraDCopyText(self.pid)
	SoraDShowMsgTip(i18n("common_text_1062"))
end
return Com_copy
