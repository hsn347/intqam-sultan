local gametop = gModuleMgr.getObject("gametop")
local activity_9001657_Ctrl = SoraDGetCtrl("activity_9001657_Ctrl")
local buildLogic = include("buildLogic")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001657_MainPanel = class("Activity_9001657_MainPanel", baseFguiPanel)
function Activity_9001657_MainPanel:ctor(...)
	Activity_9001657_MainPanel.super.ctor(self, ...)
	print("Activity_9001657_MainPanel:ctor", self.viewName)
	self.debug = true
	self.activityID = gActivityTimeActivityID.MERGE_SERVER_ACTIVITY
	self.isMoveInKingdom = activity_9001657_Ctrl:getIsMoveInKingdom()
end
function Activity_9001657_MainPanel:onInit()
	print("=======Activity_9001657_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Node_tips:setString(i18n("kingdom_merger_text1"))
	self.fields.atlantisTimeNode:initActivityData(self.activityID)
	self.fields.Button_apply:addClickListener(handler(self, self.onClickBtnApply))
	if self.isMoveInKingdom then
		self.fields.Text_des:setString(i18n("kingdom_merger_text5"))
		self.fields.Button_apply:setString(i18n("kingdom_merger_text23"))
		self.fields.Text_tip:setString(i18n("kingdom_merger_text7"))
	else
		self.fields.Text_des:setString(i18n("kingdom_merger_text2"))
		self.fields.Button_apply:setString(i18n("kingdom_merger_text3"))
		self.fields.Text_tip:setString(i18n("kingdom_merger_text4"))
	end
	self:updateBtnApplyRed()
end
function Activity_9001657_MainPanel:onShow()
	print("=======Activity_9001657_MainPanel:onShow")
end
function Activity_9001657_MainPanel:onClickHelp()
	SoraDPlaySound()
	activity_9001657_Ctrl:showFAQ()
end
function Activity_9001657_MainPanel:onClickBtnApply()
	SoraDPlaySound()
	if self.isMoveInKingdom then
		if not activity_9001657_Ctrl:checkSelfIsKing() then
			SoraDShowMsgTip(i18n("kingdom_merger_text6"))
			return
		end
		uiManager:show("Activity_9001657_Apply")
	else
		local castleLv = constantRead.getConstValue("KINGDOM_MERGER_CASTLE_LV", 60)
		if castleLv > SoraDGetCastleLv() then
			_ENV = i18n("kingdom_merger_text6")
			i18n("kingdom_merger_text6").level = buildLogic.getBuildLvStr(castleLv)
			SoraDShowMsgTip(i18n("kingdom_merger_text36", i18n("kingdom_merger_text6")))
			return
		end
		uiManager:show("Activity_9001657_Merge")
	end
end
function Activity_9001657_MainPanel:updateBtnApplyRed(...)
	if not self.isMoveInKingdom then
		return
	end
	if not activity_9001657_Ctrl:checkSelfIsKing() then
		return
	end
	local isRed = activity_9001657_Ctrl:getHasNotAgreedUser()
	self.fields.Button_apply:setReddot(isRed)
end
function Activity_9001657_MainPanel:onMsgUpdateView(...)
	self:updateBtnApplyRed()
end
function Activity_9001657_MainPanel:onIntoPanel(...)
	self:updateBtnApplyRed()
end
return Activity_9001657_MainPanel
