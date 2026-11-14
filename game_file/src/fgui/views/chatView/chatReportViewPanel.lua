local chatSendMgr = gChatMgrs:getMgr("chatSendMgr")
_ENV = gChatMgrs
gChatMgrs[gChatChannel.KINGDOM] = 1
gChatMgrs[gChatChannel.ALLIANCE] = 2
gChatMgrs[gChatChannel.TEAM] = 4
gChatMgrs[gChatChannel.MAIL] = 3
gChatMgrs[gChatChannel.ALLIANCEMSG] = 3
gChatMgrs[gChatChannel.CHATROOM] = 3
gChatMgrs[gChatChannel.TEAMMSG] = 5
local gChatMgrs[gChatChannel.DJ], chatChannel2ComplainType = 6, gChatMgrs
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local chatReportViewPanel = class("chatReportViewPanel", baseFguiPanel)
function chatReportViewPanel:ctor(...)
	chatReportViewPanel.super.ctor(self, ...)
	print("chatReportViewPanel:ctor", self.viewName)
end
function chatReportViewPanel:onInit()
	print("=======chatReportViewPanel:onInit")
	_ENV, _UPVALUE7_ = "=======chatReportViewPanel:onInit", print
	;("=======chatReportViewPanel:onInit").reportType = gChatReportType.ABUSE
	_ENV, ("=======chatReportViewPanel:onInit").key = gChatReportType.ABUSE, "common_text_3660"
	gChatReportType.ABUSE.reportType = gChatReportType.ATTACK_FAMILY
	_ENV, gChatReportType.ABUSE.key = gChatReportType.ATTACK_FAMILY, "common_text_3661"
	gChatReportType.ATTACK_FAMILY.reportType = gChatReportType.RELIGIOUS_VIOLATION
	_ENV, gChatReportType.ATTACK_FAMILY.key = gChatReportType.RELIGIOUS_VIOLATION, "common_text_3662"
	gChatReportType.RELIGIOUS_VIOLATION.reportType = gChatReportType.DISCLOSE_ONES_PRIVACY
	_ENV, gChatReportType.RELIGIOUS_VIOLATION.key = gChatReportType.DISCLOSE_ONES_PRIVACY, "common_text_3663"
	gChatReportType.DISCLOSE_ONES_PRIVACY.reportType = gChatReportType.ATTACK_STATE_LEADERS
	_ENV, gChatReportType.DISCLOSE_ONES_PRIVACY.key = gChatReportType.ATTACK_STATE_LEADERS, "common_text_3664"
	gChatReportType.ATTACK_STATE_LEADERS.reportType = gChatReportType.RESOURCE_QUOTIENT
	_ENV, gChatReportType.ATTACK_STATE_LEADERS.key = gChatReportType.RESOURCE_QUOTIENT, "report_type_res_name"
	gChatReportType.RESOURCE_QUOTIENT.reportType = gChatReportType.OTHER
	gChatReportType.RESOURCE_QUOTIENT.key = "common_text_312"
	self.arraySelections, print[1] = print, "=======chatReportViewPanel:onInit"
	self.arraySelections, print[2] = print, gChatReportType.ABUSE
	self.arraySelections, print[3] = print, gChatReportType.ATTACK_FAMILY
	self.arraySelections, print[4] = print, gChatReportType.RELIGIOUS_VIOLATION
	self.arraySelections, print[5] = print, gChatReportType.DISCLOSE_ONES_PRIVACY
	self.arraySelections, print[6] = print, gChatReportType.ATTACK_STATE_LEADERS
	self.arraySelections, print[7] = print, gChatReportType.RESOURCE_QUOTIENT
	self.curReportType = nil
	self.fields.Panel_bg:setString(i18n("common_text_3665"))
	self.fields.btn_go:setString(i18n("common_text_3666"))
	self.fields.btn_go:addClickListener(handler(self, self.onClick_btn_go))
	self.fields.btn_go:setEnabled(false)
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setScrollEnable(#self.arraySelections * 60 > self.fields.List:getHeight())
end
function chatReportViewPanel:onItemRenderer(index, obj)
	obj:initData(self.arraySelections[index + 1], index + 1, self.curReportType)
end
function chatReportViewPanel:onShow()
	print("=======chatReportViewPanel:onShow")
	self.itemsData = self.param.data
	self.chatId = self.param.chatId
	self.fields.List:setNumItems(#self.arraySelections)
end
function chatReportViewPanel:reportSelect(target, data)
	self.curReportType = data.reportType
	self.fields.List:setNumItems(#self.arraySelections)
	self.fields.btn_go:setEnabled(true)
end
function chatReportViewPanel:onClick_btn_go()
	SoraDPlaySound()
	if self.chatId and not chatSendMgr:checkReportMsg(self.chatId) then
		self:close()
		return
	end
	SoraDShowMsgTip(i18n("common_text_1452"))
	self.itemsData.reportReason = self.curReportType
	if self.itemsData.chatChannel then
		print("self.itemsData.chatChannel = ", self.itemsData.chatChannel)
		self.itemsData.complaintype = chatChannel2ComplainType[self.itemsData.chatChannel]
	end
	dump(self.itemsData, "举报内容：")
	local chatFunctions = include("chatFunctions")
	chatFunctions:sendComplain(self.itemsData)
	local gametop = gModuleMgr.getObject("gametop")
	local chatCtrl = gametop.playertop_:getModule("chatCtrl")
	chatCtrl:chatReportUser(self.itemsData.bycomplainid)
	self:close()
end
return chatReportViewPanel
