local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kohMigratePrivilegeViewPanel = class("kohMigratePrivilegeViewPanel", baseFguiPanel)
_ENV = "kohMigratePrivilegeViewPanel"
;("kohMigratePrivilegeViewPanel").APPLY = 1
;("kohMigratePrivilegeViewPanel").PRIVILEGE = 2
local ("kohMigratePrivilegeViewPanel").SETTING, pageType = 3, "kohMigratePrivilegeViewPanel"
function kohMigratePrivilegeViewPanel:ctor(...)
	kohMigratePrivilegeViewPanel.super.ctor(self, ...)
	print("kohMigratePrivilegeViewPanel:ctor", self.viewName)
	self.ccsList, kohMigratePrivilegeViewPanel, self.debug = print, print, true
	self.activityID = gActivityTimeActivityID.KOH_MIGRATE
	self.curTabIndex = pageType.APPLY
end
function kohMigratePrivilegeViewPanel:getPackageList(...)
	_UPVALUE1_ = nil
	;(nil)[1] = "newLordView"
	return nil
end
function kohMigratePrivilegeViewPanel:onInit()
	print("=======kohMigratePrivilegeViewPanel:onInit")
	self.fields.Com_title:initData(i18n("across_move_kingPower_title"), handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	self.ccs_tab = self.fields.com_Tab
end
function kohMigratePrivilegeViewPanel:onShow()
	print("=======kohMigratePrivilegeViewPanel:onShow")
	_UPVALUE3_ = "=======kohMigratePrivilegeViewPanel:onShow"
	;("=======kohMigratePrivilegeViewPanel:onShow")[1] = "CCS_kohMigratePrivilegeApply_1"
	;("=======kohMigratePrivilegeViewPanel:onShow")[2] = "CCS_kohMigratePrivilegeKing_1"
	;("=======kohMigratePrivilegeViewPanel:onShow")[3] = "CCS_kohMigratePrivilegeSetting_1"
	for i, v in ipairs("=======kohMigratePrivilegeViewPanel:onShow") do
		self.ccsList[i] = self.fields[v]
		self.ccsList[i]:setVisible(false)
	end
	self:refreshTab()
end
function kohMigratePrivilegeViewPanel:refreshTab()
	local isOpen = kohMigrateCtrl:isPrivilegeOpen()
	if self.curTabIndex == pageType.PRIVILEGE then
		self.curTabIndex = isOpen and self.curTabIndex or pageType.APPLY
	end
	if isOpen then
		self:initPrivilegeData()
	else
		self:initData()
	end
end
function kohMigratePrivilegeViewPanel:initPrivilegeData(...)
	_ENV, _ENV = nil, nil
	;(nil).title = i18n("across_approval_title")
	_ENV, (nil)[1], (nil).tag = nil, nil, pageType.APPLY
	;(nil).title = i18n("kingPower_invitation_title")
	_ENV, (nil)[2], (nil).tag = nil, nil, pageType.PRIVILEGE
	;(nil).title = i18n("across_move_set_title")
	_ENV, (nil)[3], (nil).tag = nil, nil, pageType.SETTING
	local tabsetArray
	;(nil).defaultClick = self.curTabIndex
	;(nil).tabsetArray = tabsetArray
	local (nil).callback, param = handler(self, self.btnTabClick), nil
	self.ccs_tab:initView(param)
	if param.defaultClick ~= pageType.APPLY and kohMigrateCtrl:getRecvApplyUnRead() then
		self.ccs_tab:setBtnRedDot(pageType.APPLY, true)
	end
	if param.defaultClick ~= pageType.PRIVILEGE and kohMigrateCtrl:isKingPrivilegeRead() then
		self.ccs_tab:setBtnRedDot(pageType.PRIVILEGE, true)
	end
end
function kohMigratePrivilegeViewPanel:initData(...)
	_ENV, _ENV = nil, nil
	;(nil).title = i18n("across_approval_title")
	_ENV, (nil)[1], (nil).tag = nil, nil, pageType.APPLY
	;(nil).title = i18n("across_move_set_title")
	_ENV, (nil)[2], (nil).tag = nil, nil, pageType.SETTING
	local tabsetArray
	;(nil).defaultClick = self.curTabIndex
	;(nil).tabsetArray = tabsetArray
	local (nil).callback, param = handler(self, self.btnTabClick), nil
	self.ccs_tab:initView(param)
	if param.defaultClick ~= pageType.APPLY and kohMigrateCtrl:getRecvApplyUnRead() then
		self.ccs_tab:setBtnRedDot(pageType.APPLY, true)
	end
end
function kohMigratePrivilegeViewPanel:closePanel(...)
	self:checkSettingChange(function()
		kohMigratePrivilegeViewPanel.super.closePanel(self)
	end)
end
function kohMigratePrivilegeViewPanel:btnHelpClick(target, event)
	SoraDPlaySound()
	local helpStr = i18n("across_kingPowerDesc_text02")
	_ENV = nil
	;(nil).align = SoraDFLabelR()
	SoraDShowHelpMsgTip(helpStr, nil)
end
function kohMigratePrivilegeViewPanel:btnTabClick(tag, name)
	if self.curTabIndex == pageType.SETTING and tag ~= pageType.SETTING then
		self:checkSettingChange()
	end
	if tag == pageType.PRIVILEGE then
		kohMigrateCtrl:setKingPrivilegeRed()
		self.ccs_tab:setBtnRedDot(pageType.PRIVILEGE, false)
		pageType = self.ccs_tab
		self.ccs_tab.msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMUSR_CHANGED"
		SoraDSendMessage(self.ccs_tab)
	end
	self.curTabIndex = tag
	for i, v in ipairs(self.ccsList) do
		if self.curTabIndex == i then
			v:setVisible(true)
			if v.reqData then
				v:reqData()
			end
		else
			v:setVisible(false)
		end
	end
	if kohMigrateCtrl:getRecvApplyUnRead() then
		if self.curTabIndex == pageType.APPLY then
			self:setRecvApplyUnRead(false)
			self.ccs_tab:setBtnRedDot(pageType.APPLY, false)
		else
			self.ccs_tab:setBtnRedDot(pageType.APPLY, true)
		end
	end
end
function kohMigratePrivilegeViewPanel:refreshRedPoint(target, event)
	if event.notifyType ~= gKohMigrateMsgType.isRecvApplyUnRead then
		return
	end
	if self.curTabIndex ~= pageType.APPLY then
		self.ccs_tab:setBtnRedDot(pageType.APPLY, true)
	end
end
function kohMigratePrivilegeViewPanel:setRecvApplyUnRead(unRead)
	kohMigrateCtrl:setRecvApplyUnRead(unRead)
	kohMigrateCtrl = kohMigrateCtrl
	kohMigrateCtrl.msg = "MESSAGE_KOHMIGRATE_REFRESH_REDPOINT"
	kohMigrateCtrl.notifyType = gKohMigrateMsgType.isRecvApplyUnRead
	SoraDSendMessage(kohMigrateCtrl)
end
function kohMigratePrivilegeViewPanel:checkSettingChange(callback)
	local ccs_setting = self.ccsList[pageType.SETTING]
	if ccs_setting:isSetChange() then
		local str = i18n("across_powerSet_changeSure_desc02")
		pageType = nil
		;(nil).align = SoraDFLabelR()
		;(nil).useHtml = true
		SoraDShowMsgBoxNew(str, i18n("common_text_204"), i18n("common_text_185"), function(exitType)
			if tolua.isnull(self) then
				return
			end
			if exitType == MSGBOX_CALLBACK_YES then
				ccs_setting:saveSet()
				SoraDCloseLoading(self)
			else
				ccs_setting:cleanSet()
			end
			if callback then
				callback()
			end
		end, nil)
	elseif callback then
		callback()
	end
end
return kohMigratePrivilegeViewPanel
