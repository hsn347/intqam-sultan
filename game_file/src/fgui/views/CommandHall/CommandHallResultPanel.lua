local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local commandHallRead = include("commandHallRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommandHallResultPanel = class("CommandHallResultPanel", baseFguiPanel)
function CommandHallResultPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommandHallResultPanel:ctor", self.viewName)
	self.isCanCloseSelf = false
end
function CommandHallResultPanel:onInit()
	print("=======CommandHallResultPanel:onInit")
	self.fields.Effect_1:setIsLoop(false)
	self.fields.Text_tip:setString(i18n("commandhall_text_107"))
	local armyGroupID = self.proxy.param and self.proxy.param.armyGroupID or 1
	local taskID = commandHallRead.getTaskIDByOrder(armyGroupID)
	if commandHallRead.checkTaskIsCirculate(taskID) then
		armyGroupID = tostring(armyGroupID - 1) .. "+"
	end
	_ENV = i18n("commandhall_text_107")
	i18n("commandhall_text_107").num = armyGroupID
	self.fields.Text_name2:setString(i18n("commandhall_name_1", i18n("commandhall_text_107")))
	self.fields.Button_ok:setString(i18n("GS_commandhall_guide_11"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClickBtnOk))
	local lordInfo = lordInfoCtrl:getLordInfo()
	self.fields.Text_name1:setString(lordInfo.base.nickName)
	self.fields.Com_head1:setHeadSprite()
	self.fields.Com_head2:setHeadSprite("head_sdd.png")
	if not SoraDFIsRA() then
		self.fields.Text_name1:fixPos()
		self.fields.Text_name2:fixPos()
		self.fields.Com_head1:fixPos()
		self.fields.Com_head2:fixPos()
	end
end
function CommandHallResultPanel:onShow()
	print("=======CommandHallResultPanel:onShow")
	if SoraDIsGameGuide() then
		print("==MESSAGE_SERVER_GUIDE_STEP_END=4=", SoraDIsGameGuide())
		_ENV = "==MESSAGE_SERVER_GUIDE_STEP_END=4="
		;("==MESSAGE_SERVER_GUIDE_STEP_END=4=").msg = "MESSAGE_SERVER_GUIDE_STEP_END"
		;("==MESSAGE_SERVER_GUIDE_STEP_END=4=").step = SoraDIsGameGuide()
		;("==MESSAGE_SERVER_GUIDE_STEP_END=4=").reload = false
		SoraDSendMessage("==MESSAGE_SERVER_GUIDE_STEP_END=4=")
	end
end
function CommandHallResultPanel:onClickBtnOk()
	SoraDPlaySound()
	self:closePanel()
	_ENV = nil
	;(nil).showFinish = true
	uiManager:show("CommandHallMain", nil)
end
return CommandHallResultPanel
