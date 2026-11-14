local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local kohMigrateRead = include("kohMigrateRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kohMigratePrivilegeApplySurePanel = class("kohMigratePrivilegeApplySurePanel", baseFguiPanel)
function kohMigratePrivilegeApplySurePanel:ctor(...)
	kohMigratePrivilegeApplySurePanel.super.ctor(self, ...)
	print("kohMigratePrivilegeApplySurePanel:ctor", self.viewName)
end
function kohMigratePrivilegeApplySurePanel:onInit()
	print("=======kohMigratePrivilegeApplySurePanel:onInit")
	self.fields.Button_yes:setString(i18n("common_text_204"))
	self.fields.Button_yes:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Button_no:setString(i18n("common_text_185"))
	self.fields.Button_no:addClickListener(handler(self, self.onClickClose))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function kohMigratePrivilegeApplySurePanel:onShow()
	print("=======kohMigratePrivilegeApplySurePanel:onShow")
	if not self.param then
		local _ENV, param = self.param, self.param
	end
	if param.initData then
		self:initData(param.data, param.isKingPrivilege)
	elseif param.initData_9001657 then
		self:initData_9001657(param.data)
	end
end
function kohMigratePrivilegeApplySurePanel:initData(data, isKingPrivilege)
	self.data = data
	self.isKingPrivilege = isKingPrivilege or false
	self.fields.Text_msg:setString(self.isKingPrivilege and i18n("kingPower_invitation_sure_desc") or i18n("across_approvalAgreeSure_desc"))
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	local nameStr = textParser.formatPlayerName(data.allianceAbb, data.name, data.kid)
	self.fields.Text_name:setString(nameStr)
	local legend = kohMigrateRead.getPlayerLegend(data.uid)
	if legend then
		self.fields.Image_power:setSize(cc.size(40, 40))
		self.fields.Image_power:setURL("icon_kfqc_cqph.png")
		self.fields.Text_power:setString(string.formatnumberthousands(legend))
	else
		self.fields.Text_power:setString(string.formatnumberthousands(data.strength or 0))
	end
	self.fields.Com_castleLv:initData(data.castleLv, data.starLv)
end
function kohMigratePrivilegeApplySurePanel:btnClickCallBack()
	SoraDPlaySound()
	if self.activityID and self.activityID == gActivityTimeActivityID.MERGE_SERVER_ACTIVITY then
		self:btnClick_9001657()
		return
	end
	if self.isKingPrivilege then
		if kohMigrateCtrl:isPrivilegeOpen() then
			SoraDShowLoading()
			kohMigrateCtrl:reqSendSpecInvite(self.data.uid)
		else
			SoraDShowMsgTip(i18n("tips_across_kingPower_notOpen02"))
		end
	else
		SoraDShowLoading()
		kohMigrateCtrl:reqAcceptExtraApply(self.data.uid)
	end
	self:removeFromParent()
end
function kohMigratePrivilegeApplySurePanel:initData_9001657(data)
	self.activityID = gActivityTimeActivityID.MERGE_SERVER_ACTIVITY
	self.data = data
	self.fields.Text_msg:setString(i18n("across_approvalAgreeSure_desc"))
	self.fields.Com_head:setHeadSprite(data.iconID, "")
	local playerName = textParser.formatPlayerName(data.allianceAbbr, data.nickName, data.kid)
	self.fields.Text_name:setString(playerName)
	self.fields.Image_power:setSize(cc.size(30, 25))
	self.fields.Image_power:setURL("icon_legendaryking_fight.png")
	self.fields.Text_power:setString(string.formatnumberthousands(data.totalFc))
	self.fields.Com_castleLv:initData(data.cityLevel, data.starLv)
end
function kohMigratePrivilegeApplySurePanel:btnClick_9001657()
	local activity_9001657_Ctrl = SoraDGetCtrl("activity_9001657_Ctrl")
	activity_9001657_Ctrl:reqAgreeApply(self.data.uid)
	self:removeFromParent()
end
return kohMigratePrivilegeApplySurePanel
