local djRead = include("djRead")
local djCtrl = SoraDGetCtrl("djCtrl")
local chatFunctions = include("chatFunctions")
_ENV, _UPVALUE7_ = nil, "chatFunctions"
;(nil).reportType = gChatReportType.ABUSE
_ENV, (nil).key = gChatReportType.ABUSE, "common_text_3660"
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
;("chatFunctions")[1] = nil
;("chatFunctions")[2] = gChatReportType.ABUSE
;("chatFunctions")[3] = gChatReportType.ATTACK_FAMILY
;("chatFunctions")[4] = gChatReportType.RELIGIOUS_VIOLATION
;("chatFunctions")[5] = gChatReportType.DISCLOSE_ONES_PRIVACY
;("chatFunctions")[6] = gChatReportType.ATTACK_STATE_LEADERS
local ("chatFunctions")[7], arraySelections = gChatReportType.RESOURCE_QUOTIENT, "chatFunctions"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjAudienceManagePanel = class("DjAudienceManagePanel", baseFguiPanel)
function DjAudienceManagePanel:ctor(...)
	self.isLRU = true
	DjAudienceManagePanel.super.ctor(self, ...)
	print("DjAudienceManagePanel:ctor", self.viewName)
end
function DjAudienceManagePanel:onInit()
	print("=======DjAudienceManagePanel:onInit")
	self.fields.List_time:setItemRenderer(handler(self, self.itemRenderer_List_time))
	self.fields.List_time:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.Panel_bg:setString(i18n("Anchor_text_148"))
	self.fields.Button_set:setTitle(i18n("Anchor_text_153"))
	self.fields.Button_set:addClickListener(handler(self, self.onClick_Button_set))
	self.fields.Label_title:setString(i18n("Anchor_text_149"))
	self.fields.Text_chat:setString(i18n("Anchor_text_150"))
	self.fields.Text_enter:setString(i18n("Anchor_text_151"))
	self.fields.Text_report:setString(i18n("Anchor_text_152"))
	self.view:fixChildrenPos()
end
function DjAudienceManagePanel:endShow()
	print("=======DjAudienceManagePanel:endShow")
	self.uid = self.param.uid
	self.message = self.param.message
	self.fields.Check_tick_chat:setSelected(false)
	self.fields.Check_tick_enter:setSelected(false)
	self.fields.Check_tick_report:setSelected(false)
	self.curTypeIndex = 0
	self.curType = gChatReportType.ABUSE
	local _ENV, items = gChatReportType.ABUSE, gChatReportType.ABUSE
	local _ENV, values = self.fields.Check_tick_report, self.fields.Check_tick_report
	for k, v in ipairs(arraySelections) do
		table.insert(items, i18n(v.key))
		table.insert(values, v.reportType)
	end
	_ENV = nil
	;(nil).items = items
	;(nil).values = values
	;(nil).changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox, nil)
	local dropdown = self.fields.ComboBox:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.curTypeIndex)
	end)
	self.fields.ComboBox:fixChildrenPos()
	self.List_timeData = djRead.getBlacklistCfg(2, 1)
	self.fields.List_time:setNumItems(#self.List_timeData)
	djCtrl:reqGetAudienceInfo(self.uid)
	SoraDShowLoading(self)
end
function DjAudienceManagePanel:onComboBoxClick()
	SoraDPlaySound()
	self.curTypeIndex = tonumber(self.fields.ComboBox:getSelectedIndex())
	self.curType = tonumber(self.fields.ComboBox:getValue())
end
function DjAudienceManagePanel:initView(target, data)
	SoraDCloseLoading(self)
	self.data = data.data
	self.fields.Com_head:setHeadSprite(self.data.info.imageId, self.data.info.avatar)
	self.fields.Com_head:setPlayerID(self.data.info.uid)
	self.fields.Com_head:setKid(self.data.info.kid)
	self.fields.Text_name:setString(self.data.info.nickName)
	_ENV = nil
	;(nil).conten = self.data.info.alliance or i18n("common_text_826")
	self.fields.Text_alliance:setString(i18n("common_text_925", nil))
	_ENV = i18n("common_text_925", nil)
	i18n("common_text_925", nil).time = fguiHelper.getColorString("#F0E6D2", SoraDConvertSecondToString(self.data.listenTotalTime))
	self.fields.Text_time:setString(i18n("Anchor_text_190", i18n("common_text_925", nil)))
	_ENV = i18n("Anchor_text_190", i18n("common_text_925", nil))
	i18n("Anchor_text_190", i18n("common_text_925", nil)).val = fguiHelper.getColorString("#F0E6D2", string.formatnumberthousands(self.data.exp))
	self.fields.Text_value:setString(i18n("Anchor_text_191", i18n("Anchor_text_190", i18n("common_text_925", nil))))
	if not self.data.permissionList then
		local _ENV, permissionList = self.data.permissionList, self.data.permissionList
	end
	self.selIndex = permissionList[1] or 0
	if self.selIndex > 0 then
		self.fields.List_time:setSelectedIndex(self.selIndex - 1)
	end
	self.fields.Check_tick_chat:setSelected((permissionList[2] or 0) ~= 0)
	self.fields.Check_tick_enter:setSelected((permissionList[3] or 0) ~= 0)
end
function DjAudienceManagePanel:onClickItem()
	SoraDPlaySound()
	if self.selIndex > 0 and self.fields.List_time:getSelectedIndex() == self.selIndex - 1 then
		self.fields.List_time:setSelectedIndex(self.selIndex - 1)
	else
		self.selIndex = self.fields.List_time:getSelectedIndex() + 1
	end
end
function DjAudienceManagePanel:itemRenderer_List_time(index, obj)
	local val = self.List_timeData[index + 1]
	obj:fixChildrenPos()
	if index + 1 ~= #self.List_timeData or not i18n("common_text_1995") then
		_ENV = nil
		;(nil).sec = val
	end
	obj:setTitle((i18n("common_text_666", nil)))
end
function DjAudienceManagePanel:onClick_Button_set(context)
	SoraDPlaySound()
	if self.fields.Check_tick_report:isSelected() then
		_ENV = nil
		;(nil).bycomplainid = self.uid
		;(nil).complainid = SoraDGetPlayerID()
		;(nil).message = self.message
		;(nil).serverid = self.data.info.kid
		;(nil).reportReason = self.curType
		;(nil).chatChannel = gChatChannel.DJ
		;(nil).complaintype = 6
		;(nil).targetName = self.data.info.nickName
		;(nil).messagetime = serviceFunctions.systemTime()
		chatFunctions:sendComplain(nil)
	end
	_UPVALUE3_ = chatFunctions.sendComplain
	chatFunctions.sendComplain[1] = self.selIndex
	chatFunctions.sendComplain[2] = self.fields.Check_tick_chat:isSelected() and 1 or 0
	local chatFunctions.sendComplain[3], permissionList = self.fields.Check_tick_enter:isSelected() and 1 or 0, chatFunctions.sendComplain
	djCtrl:reqSetUserBlack(self.uid, permissionList)
	self:close()
end
return DjAudienceManagePanel
