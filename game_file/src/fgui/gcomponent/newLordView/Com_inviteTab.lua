local gametop = gModuleMgr.getObject("gametop")
local accountExtCtrl = gametop.playertop_:getModule("accountExtCtrl")
local gameInviteltCtrl = include("gameInviteltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_inviteTab = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_inviteTab", Com_inviteTab)
function Com_inviteTab:onInit()
	self.fields.Button_copy:fixPos()
	self.fields.Text_mineCode:fixPos()
	accountExtCtrl = self.fields.Text_mineCode.fixPos
	self.fields.Text_mineCode.fixPos.code = accountExtCtrl:getAccountInviteCode()
	self.collectData, self.fields.Text_mineCode.fixPos.count = self.fields.Text_mineCode.fixPos, accountExtCtrl:getInviteNum()
	self.fields.Button_copy:setTitleText(i18n("common_text_078"))
	self.fields.Button_copy:addClickListener(handler(self, self.btnCopyClick))
	accountExtCtrl = handler(self, self.btnCopyClick)
	accountExtCtrl, accountExtCtrl, handler(self, self.btnCopyClick).code = handler(self, self.btnCopyClick)
	self.collectData.code.__default, handler(self, self.btnCopyClick).u = handler(self, self.btnCopyClick)
	self.fields.Text_mineCode:setString(i18n_html("invite_text_10", handler(self, self.btnCopyClick)))
	accountExtCtrl = i18n_html("invite_text_10", handler(self, self.btnCopyClick))
	i18n_html("invite_text_10", handler(self, self.btnCopyClick)).num = self.collectData.count
	self.fields.Text_inviteNum:setString(i18n("common_text_975", i18n_html("invite_text_10", handler(self, self.btnCopyClick))))
	accountExtCtrl = i18n("common_text_975", i18n_html("invite_text_10", handler(self, self.btnCopyClick)))
	i18n("common_text_975", i18n_html("invite_text_10", handler(self, self.btnCopyClick))).gold = string.formatnumberthousands(20000)
	self.fields.Text_goldTip:setString(i18n("invite_text_06", i18n("common_text_975", i18n_html("invite_text_10", handler(self, self.btnCopyClick)))))
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
function Com_inviteTab:onShow()
	self.fields.Node_inviteGift:initData(i18n("invite_text_01"), gameInviteltCtrl.getShowItemListByType(gGameInviteType.PEOPLE), gGameInviteType.PEOPLE)
	self.fields.Node_castleGift:initData(i18n("invite_text_04"), gameInviteltCtrl.getShowItemListByType(gGameInviteType.PEOPLECASTLE), gGameInviteType.PEOPLECASTLE)
end
function Com_inviteTab:registerEvent()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", handler(self, self.shareFacebookSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_INPUTTHEINVITECODE", handler(self, self.doInvite))
end
function Com_inviteTab:doInvite()
	accountExtCtrl = nil
	;(nil).code = accountExtCtrl:getAccountInviteCode()
	self.collectData, (nil).count = nil, accountExtCtrl:getInviteNum()
	accountExtCtrl = nil
	;(nil).num = self.collectData.count
	self.fields.Text_inviteNum:setString(i18n("common_text_975", nil))
end
function Com_inviteTab:btnCopyClick()
	SoraDPlaySound()
	SoraDCopyText(self:getShareContentText())
	print("self:getShareContentText()=", self:getShareContentText())
	SoraDShowMsgTip(i18n("common_text_1062"))
	self:recordPost(gGameInvitePlatform.COPY)
end
function Com_inviteTab:btnPlatformClick(btnID)
	SoraDPlaySound()
	if gGameInvitePlatform.FACEBOOK == btnID then
		self:shareToFaceBook()
	elseif gGameInvitePlatform.WHATSAPP == btnID then
		self:shareToWhatsapp()
	elseif gGameInvitePlatform.TELEGRAM == btnID then
		self:shareToTelegram()
	elseif gGameInvitePlatform.KAKOOTALK == btnID then
		self:shareToKakootalk()
	end
	self:recordPost(btnID)
end
function Com_inviteTab:getShareContentText(cid)
	local invCode = accountExtCtrl:getAccountInviteCode()
	accountExtCtrl = nil
	;(nil).code = invCode
	;(nil).url = self.getShareUrl(cid)
	return i18n("invite_text_08", nil)
end
function Com_inviteTab.getShareUrl(cid)
	return SoraGetGameShareUrl("invite", cid or "copy")
end
function Com_inviteTab:shareToWhatsapp()
	local invCode = accountExtCtrl:getAccountInviteCode()
	if device.platform == "android" then
		local javaClassName = "org/cocos2dx/lua/AchievementModule"
		local javaMethodName = "sendWhatsApp"
		accountExtCtrl = nil
		;(nil)[1] = self:getShareContentText(2)
		;(nil)[2] = self:getShareContentText(2)
		;(nil)[3] = self:getShareContentText(2)
		;(nil)[4] = self:getShareContentText(2)
		;(nil)[5] = self:getShareContentText(2)
		local (nil)[6], javaParams = self:getShareContentText(2)
		local javaMethodSig = "(Ljava/lang/String;)V"
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
	elseif device.platform == "ios" then
		accountExtCtrl = device.platform
		local device.platform.contentText, args = self:getShareContentText(2), device.platform
		local ok, ret = luaoc.callStaticMethod("NCSGameCenter", "sendWhatsApp", args)
	end
end
function Com_inviteTab:shareToTelegram()
	local invCode = accountExtCtrl:getAccountInviteCode()
	if device.platform == "android" then
		local javaClassName = "org/cocos2dx/lua/AchievementModule"
		local javaMethodName = "sendTelegram"
		accountExtCtrl = nil
		;(nil)[1] = self:getShareContentText(3)
		;(nil)[2] = self:getShareContentText(3)
		;(nil)[3] = self:getShareContentText(3)
		;(nil)[4] = self:getShareContentText(3)
		;(nil)[5] = self:getShareContentText(3)
		local (nil)[6], javaParams = self:getShareContentText(3)
		local javaMethodSig = "(Ljava/lang/String;)V"
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
	elseif device.platform == "ios" then
		accountExtCtrl = device.platform
		local device.platform.contentText, args = self:getShareContentText(3), device.platform
		local ok, ret = luaoc.callStaticMethod("NCSGameCenter", "sendTelegram", args)
	end
end
function Com_inviteTab:shareToKakootalk()
	local content = self:getShareContentText(4)
	print(content)
	userSDKManager.shareToKakaoTalk(self:getShareContentText(4))
end
function Com_inviteTab:shareToFaceBook()
	print("我试试看这里会不会两次")
	local channel = userSDKManager.getChannel()
	local isBeta = userSDKManager.isBeta()
	local url = self.getShareUrl(gGameInvitePlatform.FACEBOOK)
	userSDKManager.shareFacebookLinkContent(url)
end
function Com_inviteTab:shareToTwitter()
	_ENV = nil
	;(nil).title = i18n("common_text_1012")
	;(nil).url = _url
	;(nil).code = invCode
	local contentText = i18n("common_text_2268", nil)
	userSDKManager.sendTwitter(contentText)
end
function Com_inviteTab:shareFacebookSuccess()
	SoraDShowMsgTip(i18n("notice_0103"))
end
function Com_inviteTab:shareFacebookFail()
	SoraDShowMsgTip(i18n("common_text_1034"))
end
function Com_inviteTab:recordPost(_channel)
	local invCode = accountExtCtrl:getAccountInviteCode()
	accountExtCtrl = nil
	;(nil).channel = _channel
	;(nil).invite_code = invCode
	userSDKManager.logEvent(gSDKDef.TDonEvent.invite_friends_log, nil)
end
return Com_inviteTab
