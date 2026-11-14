local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_NoticePopPanel = class("RoaringFlame_NoticePopPanel", baseFguiPanel)
function RoaringFlame_NoticePopPanel:ctor(...)
	RoaringFlame_NoticePopPanel.super.ctor(self, ...)
	print("RoaringFlame_NoticePopPanel:ctor", self.viewName)
end
function RoaringFlame_NoticePopPanel:onInit()
	print("=======RoaringFlame_NoticePopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("flames_dunes_text85"))
	self.fields.input:setPromptHolder(i18n("flames_dunes_text86"), "#693815")
	self.fields.input:setMaxLength(100)
	self.fields.Button_publish:setString(i18n("flames_dunes_text85"))
	self.fields.Button_publish:addClickListener(handler(self, self.btnNoticeClick))
end
function RoaringFlame_NoticePopPanel:onShow()
	print("=======RoaringFlame_NoticePopPanel:onShow")
end
function RoaringFlame_NoticePopPanel:btnNoticeClick()
	SoraDPlaySound()
	if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.RELEASE_NOTICE, true) then
		return
	end
	local content = self.fields.input:getText()
	if #content == 0 then
		SoraDShowMsgTip(i18n("flames_dunes_text87"))
		return
	end
	roaringFlameWarCtrl:reqReleaseNotice(content)
	self:close()
end
return RoaringFlame_NoticePopPanel
