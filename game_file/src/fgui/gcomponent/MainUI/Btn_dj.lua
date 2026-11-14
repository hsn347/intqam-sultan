local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local djCtrl = SoraDGetCtrl("djCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_dj = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_dj", Btn_dj)
function Btn_dj:onInit()
	self.fields.title:setString(i18n("Anchor_text_69"))
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_dj:onShow()
end
function Btn_dj:initData()
	self:setReddot(djCtrl:isBeInvite())
end
function Btn_dj:onBtnClick()
	SoraDPlaySound()
	if worldMapDefine.isInWar() or not lordInfoCtrl:isInSelfKid() then
		SoraDShowMsgTip(i18n("Anchor_text_201"))
		return
	end
	VoiceChatSDKManager:getInstance():req4Permission()
	if djCtrl.curListenUid then
		_ENV = i18n("Anchor_text_201")
		i18n("Anchor_text_201").djUid = djCtrl.curListenUid
		uiManager:show("DjView", i18n("Anchor_text_201"))
	else
		uiManager:show("DjList")
	end
	djCtrl:resetBeInvite()
	self:setReddot(false)
end
return Btn_dj
