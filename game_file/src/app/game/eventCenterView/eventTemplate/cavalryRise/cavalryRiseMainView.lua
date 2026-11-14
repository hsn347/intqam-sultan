local gametop = gModuleMgr.getObject("gametop")
local cavalryRiseCtrl = gametop.playertop_:getModule("cavalryRiseCtrl")
local cavalryRiseMainView = class("cavalryRiseMainView", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("cavalryRiseMainView")
	end
	local cavalryRiseTab = include("cavalryRiseTab")
	target = cavalryRiseTab.new(target)
	return target
end)
_ENV = "cavalryRiseMainView"
;("cavalryRiseMainView").MAIN_VIEW_TYPE_AWARD = 1
;("cavalryRiseMainView").MAIN_VIEW_TYPE_TASK = 2
local ("cavalryRiseMainView").MAIN_VIEW_TYPE_SHOP, MAIN_VIEW_TYPE = 3, "cavalryRiseMainView"
function cavalryRiseMainView:ctor()
	self.activityType = cavalryRiseCtrl:getClassType()
	self.isHideCurrentSceneView = true
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:setVisible(false)
	self.title:setTitle(i18n(self.activityType == 1 and "activity_name_9001351" or "activity_name_9001351"))
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	self.Node_Award = SoraDGetChildByName(self, "Node_Award")
	self.nodeRedAward = SoraDGetChildByName(self, "Node_red_award")
	cavalryRiseCtrl, self.nodeRedTask = SoraDGetChildByName(self, "Node_red_task"), SoraDGetChildByName(self, "Node_red_task")
	cavalryRiseCtrl = "Node_red_task"
	;("Node_red_task").title = "Button_Award"
	SoraDGetChildByName(self, "Node_red_task")[MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_AWARD], ("Node_red_task").titleText = "Node_red_task", "cavalryrise_text_01"
	cavalryRiseCtrl = "Node_red_task"
	;("Node_red_task").title = "Button_Task"
	SoraDGetChildByName(self, "Node_red_task")[MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_TASK], ("Node_red_task").titleText = "Node_red_task", "cavalryrise_text_02"
	local tableData = SoraDGetChildByName(self, "Node_red_task")
	self:initTabData(tableData)
	self:initShowBtn(MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_AWARD)
	self:updateRedPacketTip()
end
function cavalryRiseMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_CAVALRY_RISE_GOLD", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_CAVALRY_RISE_AWARD", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_CAVALRY_RISE_LV", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_CAVALRY_RISE_EXP", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function cavalryRiseMainView:initShowBtn_post()
end
function cavalryRiseMainView:createPanel(showViewType)
	local panel
	print("cavalryRiseMainView-activityType: ", self.activityType)
	if showViewType == MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_AWARD then
		panel = SoraDCreatePanelByFixName("cavalryRiseMainAwardView")
		panel:addTo(self.Node_Award, -1)
		panel:setPosition(cc.p(display.width / 2, display.height / 2))
		panel:init()
	elseif showViewType == MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_TASK then
		panel = SoraDCreatePanelByFixName("cavalryRiseMainTaskView")
		panel:setPosition(SoraDFPoint(0, 810, 0))
		panel:addTo(self.nodeTop, -2)
		panel:init()
	end
	return panel
end
local showRedPacketTip = function(node, show)
	if show then
		node:setVisible(true)
		local txt = SoraDGetChildByName(node, "Text_num")
		txt:setVisible(false)
	else
		node:setVisible(false)
	end
end
function cavalryRiseMainView:updateRedPacketTip()
	do
		local bRed = cavalryRiseCtrl:getAwardReceiveStatusAndCount()
		showRedPacketTip(self.nodeRedAward, bRed)
	end
	do
		local bRed = cavalryRiseCtrl:getTaskReceiveStatusAndNum()
		showRedPacketTip(self.nodeRedTask, bRed)
	end
end
function cavalryRiseMainView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSingleType.CAVALRY_RISE)
	end
end
function cavalryRiseMainView:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CAVALRY_RISE_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return cavalryRiseMainView
