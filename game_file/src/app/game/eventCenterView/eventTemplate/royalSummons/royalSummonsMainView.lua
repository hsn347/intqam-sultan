local gametop = gModuleMgr.getObject("gametop")
local royalSummonsCtrl = gametop.playertop_:getModule("royalSummonsCtrl")
local royalSummonsMainView = class("royalSummonsMainView", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("royalSummonsMainView")
	end
	local royalSummonsTab = include("royalSummonsTab")
	target = royalSummonsTab.new(target)
	return target
end)
_ENV = "royalSummonsMainView"
;("royalSummonsMainView").MAIN_VIEW_TYPE_AWARD = 1
;("royalSummonsMainView").MAIN_VIEW_TYPE_TASK = 2
local ("royalSummonsMainView").MAIN_VIEW_TYPE_SHOP, MAIN_VIEW_TYPE = 3, "royalSummonsMainView"
local colorGray = cc.c3b(123, 123, 123)
local colorNormal = cc.c3b(255, 255, 255)
function royalSummonsMainView:ctor()
	self.activityType = royalSummonsCtrl:getClassType()
	self.isHideCurrentSceneView = true
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnHelp:setVisible(self.activityType == 1)
	self.title:setTitle(i18n(self.activityType == 1 and "summoned_name_01" or "summoned_name_02"))
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	self.nodeRedAward = SoraDGetChildByName(self, "Node_red_award")
	self.nodeRedTask = SoraDGetChildByName(self, "Node_red_task")
	royalSummonsCtrl, self.nodeRedExchange = SoraDGetChildByName(self, "Node_red_exchange"), SoraDGetChildByName(self, "Node_red_exchange")
	royalSummonsCtrl = "Node_red_exchange"
	;("Node_red_exchange").title = "Button_Award"
	SoraDGetChildByName(self, "Node_red_exchange")[MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_AWARD], ("Node_red_exchange").titleText = "Node_red_exchange", "common_text_2078"
	royalSummonsCtrl = "Node_red_exchange"
	;("Node_red_exchange").title = "Button_Task"
	SoraDGetChildByName(self, "Node_red_exchange")[MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_TASK], ("Node_red_exchange").titleText = "Node_red_exchange", "common_text_675"
	royalSummonsCtrl = "Node_red_exchange"
	;("Node_red_exchange").title = "Button_Shop"
	SoraDGetChildByName(self, "Node_red_exchange")[MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_SHOP], ("Node_red_exchange").titleText = "Node_red_exchange", "common_text_1809"
	local tableData = SoraDGetChildByName(self, "Node_red_exchange")
	self:initTabData(tableData)
	self:initShowBtn(MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_AWARD)
	self:updateRedPacketTip()
end
function royalSummonsMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_SHOP_NOTIFY", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_SHOP", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_TASK", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_GOLD", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_SERVER_ROYAL_SUMMONS_AWARD", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function royalSummonsMainView:initShowBtn_post()
end
function royalSummonsMainView:createPanel(showViewType)
	print("royalSummonsMainView-activityType: ", self.activityType)
	if showViewType == MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_AWARD then
		panel = SoraDCreatePanelByFixName(self.activityType == 1 and "royalSummonsMainAwardView" or "dashToSkyAwardView")
		panel:setPosition(SoraDFPoint(0, 810, 0))
		panel:addTo(self.nodeTop, -1)
		panel:init()
	elseif showViewType == MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_TASK then
		panel = SoraDCreatePanelByFixName(self.activityType == 1 and "royalSummonsMainTaskView" or "dashToSkyTaskView")
		panel:setPosition(SoraDFPoint(0, 810, 0))
		panel:addTo(self.nodeTop, -2)
		panel:init()
	elseif showViewType == MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_SHOP then
		panel = SoraDCreatePanelByFixName(self.activityType == 1 and "royalSummonsMainShopView" or "dashToSkyShopView")
		panel:setPosition(SoraDFPoint(0, 820, 0))
		panel:addTo(self.nodeTop, -3)
		panel:init()
	end
	return panel
end
local showRedPacketTip = function(node, num)
	if 0 < num then
		node:setVisible(true)
		local txt = SoraDGetChildByName(node, "Text_num")
		txt:setString(num)
	else
		node:setVisible(false)
	end
end
function royalSummonsMainView:updateRedPacketTip()
	do
		local num = royalSummonsCtrl:getAwardNum()
		showRedPacketTip(self.nodeRedAward, num)
	end
	do
		local num = royalSummonsCtrl:getTaskNum()
		showRedPacketTip(self.nodeRedTask, num)
	end
	do
		local num = royalSummonsCtrl:getExchangeNotifyNum()
		showRedPacketTip(self.nodeRedExchange, num)
	end
end
function royalSummonsMainView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.ROYAL_SUMMONS)
	end
end
function royalSummonsMainView:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ROYAL_SUMMONS) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return royalSummonsMainView
