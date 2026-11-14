local gametop = gModuleMgr.getObject("gametop")
local ancientReelCtrl = gametop.playertop_:getModule("ancientReelCtrl")
local ancientReelMainView = class("ancientReelMainView", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("ancientReelMainView")
	end
	return target
end)
_ENV = "ancientReelMainView"
;("ancientReelMainView").MAIN_VIEW_TYPE_AWARD = 1
;("ancientReelMainView").MAIN_VIEW_TYPE_TASK = 2
local ("ancientReelMainView").MAIN_VIEW_TYPE_SHOP, MAIN_VIEW_TYPE = 3, "ancientReelMainView"
function ancientReelMainView:ctor()
	self.isHideCurrentSceneView = true
	self.title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.title:setTitle(i18n("activity_name_9001271"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.nodeTop = SoraDGetChildByName(self, "Top_Node_Content")
	_ENV, _ENV, self.nodeCommonTabBtn = self, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	self.title = i18n("common_text_2078")
	self.handle = handler(self, self.btnTabClick)
	_ENV, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")[1], self.tag = self, self, MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_AWARD
	self.title = i18n("common_text_675")
	self.handle = handler(self, self.btnTabClick)
	_ENV, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")[2], self.tag = self, self, MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_TASK
	self.title = i18n("common_text_1809")
	self.handle = handler(self, self.btnTabClick)
	self.tableData, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")[3], self.tag = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), self, MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_SHOP
	_ENV = MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_SHOP
	MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_SHOP.tabNum = #self.tableData
	MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_SHOP.defaultClick = 1
	MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_SHOP.tabsetArray = self.tableData
	self.nodeCommonTabBtn:initView(MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_SHOP)
	self:updateRedPacketTip()
end
function ancientReelMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ANCIENT_REEL_GOLD", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_SERVER_ANCIENT_REEL_AWARD", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_RESET_TASK", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.updateRedPacketTip))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function ancientReelMainView:btnTabClick(showViewType)
	if self.showViewType == showViewType then
		return
	end
	self.showViewType = showViewType
	for i, v in ipairs(self.tableData) do
		local show = i == showViewType
		if show then
			if not v.panel then
				v.panel = self:createPanel(showViewType)
			end
			if v.panel then
				v.panel:setVisible(true)
			end
		elseif v.panel then
			v.panel:setVisible(false)
		end
	end
end
function ancientReelMainView:createPanel(showViewType)
	local panel
	if showViewType == MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_AWARD then
		panel = SoraDCreatePanelByFixName("ancientReelMainAwardView")
		panel:setPosition(SoraDFPoint(0, 810, 0))
		panel:addTo(self.nodeTop, -1)
		panel:init()
	elseif showViewType == MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_TASK then
		panel = SoraDCreatePanelByFixName("ancientReelMainTaskView")
		panel:setPosition(SoraDFPoint(0, 810, 0))
		panel:addTo(self.nodeTop, -2)
		panel:init()
	elseif showViewType == MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_SHOP then
		panel = SoraDCreatePanelByFixName("ancientReelMainShopView")
		panel:setPosition(SoraDFPoint(0, 820, 0))
		panel:addTo(self.nodeTop, -3)
		panel:init()
	end
	return panel
end
function ancientReelMainView:updateRedPacketTip()
	do
		local num = ancientReelCtrl:getAwardNum()
		self.nodeCommonTabBtn:setBigRedPointCount(MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_AWARD, num)
	end
	do
		local num = ancientReelCtrl:getTaskNum()
		self.nodeCommonTabBtn:setBigRedPointCount(MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_TASK, num)
	end
	do
		local num = ancientReelCtrl:getExchangeNotifyNum()
		self.nodeCommonTabBtn:setBigRedPointCount(MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_SHOP, num)
	end
end
function ancientReelMainView:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "Ancient_reel_text_03"
		;("Ancient_reel_text_03").float = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("Ancient_reel_text_03"), "Ancient_reel_text_03")
	end
end
function ancientReelMainView:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANCIENT_REEL_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return ancientReelMainView
