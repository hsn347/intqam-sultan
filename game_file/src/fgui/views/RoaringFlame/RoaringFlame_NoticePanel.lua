local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_NoticePanel = class("RoaringFlame_NoticePanel", baseFguiPanel)
function RoaringFlame_NoticePanel:ctor(...)
	RoaringFlame_NoticePanel.super.ctor(self, ...)
	print("RoaringFlame_NoticePanel:ctor", self.viewName)
end
function RoaringFlame_NoticePanel:onInit()
	print("=======RoaringFlame_NoticePanel:onInit")
	self.noticeList, _ENV = print, print
	self.fields.Com_title:initData(i18n("flames_dunes_text70"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_none:setString(i18n("god_beast_text_16"))
	self.fields.Text_none:setVisible(false)
	self.fields.Button_notice:setString(i18n("flames_dunes_text85"))
	self.fields.Button_notice:addClickListener(handler(self, self.btnNoticeClick))
	self.fields.Button_notice:setVisible(false)
end
function RoaringFlame_NoticePanel:onItemRenderer(index, obj)
	obj:initData(self.noticeList[index + 1])
end
function RoaringFlame_NoticePanel:onShow()
	print("=======RoaringFlame_NoticePanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
end
function RoaringFlame_NoticePanel:initData()
	self.noticeList = roaringFlameWarCtrl:getNoticeList()
	self.fields.List:setNumItems(#self.noticeList)
	self.fields.Text_none:setVisible(#self.noticeList == 0)
	if roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.RELEASE_NOTICE) then
		self.fields.Button_notice:setVisible(true)
	else
		self.fields.Button_notice:setVisible(false)
	end
end
function RoaringFlame_NoticePanel:btnNoticeClick()
	SoraDPlaySound()
	if not roaringFlameWarUtil.checkPermission(ROARING_FLAME_WAR_PERMISSION.RELEASE_NOTICE, true) then
		return
	end
	local curState = roaringFlameWarCtrl:getCurState()
	if curState < ROARING_FLAME_WAR_STATE.BATTLE then
		SoraDShowMsgTip(i18n("flames_dunes_text291"))
		return
	end
	uiManager:show("RoaringFlame_NoticePop")
end
function RoaringFlame_NoticePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("flames_dunes_second_rule09")
	;(nil).content = i18n("flames_dunes_second_rule10")
	uiManager:show("RuleView", nil)
end
return RoaringFlame_NoticePanel
