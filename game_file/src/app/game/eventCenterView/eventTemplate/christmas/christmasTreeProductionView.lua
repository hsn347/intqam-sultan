local gametop = gModuleMgr.getObject("gametop")
local christmasTreeCtrl = gametop.playertop_:getModule("christmasTreeCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local christmasTreeProductionView = class("christmasTreeProductionView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("christmasTreeProductionView")
	end
	return target
end)
local PANEL_SINGLE_HEIGHT = 239
local CORLOR_GREY = cc.c3b(120, 120, 120)
local CORLOR_NORMAL = cc.c3b(255, 255, 255)
function christmasTreeProductionView:ctor()
	self:initControls()
	self:initScroll()
end
function christmasTreeProductionView:initControls()
	self.bg = SoraDGetChildByName(self, "Image_bg")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_eventCenter")
	self.btnQuest = SoraDGetChildByName(self, "btn_quest")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_2")
	self.txtTime = SoraDGetChildByName(self, "text_time")
	self.txtTime = SoraDCreateTimerLabel(self, self.txtTime)
	self.txtTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	self.txtTime:setTimeEndListener(function()
		self:removeFromParent()
	end)
	self.nodeSingle = SoraDGetChildByName(self, "Node_7")
	self.btnClick = SoraDGetChildByName(self, "btn_click")
	self.bg:setFillType(1)
	self.nodeTitle:setTitle(i18n("christmas_tree_text_01"))
	self.btnQuest:addTouchEventListener(handler(self, self.questClickCallBack))
	self.btnClick:addTouchEventListener(handler(self, self.enterClickCallBack))
	local treeTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.CHRISTMAS_TREE_PRODUCTION)
	if treeTime then
		self.txtTime:beginTime(treeTime.timerNode.timer:getRemainTime())
	end
end
function christmasTreeProductionView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function christmasTreeProductionView:initScroll()
	self.scroll:removeAllChildren()
	local scrollH = math.max(3 * PANEL_SINGLE_HEIGHT, self.scroll:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(display.width, scrollH))
	for i = 1, 3 do
		local panel = self.nodeSingle:clone()
		panel:setPosition(cc.p(self.scroll:getContentSize().width / 2, scrollH - PANEL_SINGLE_HEIGHT * (i - 1)))
		panel:addTo(self.scroll)
		local panelSingleBg = SoraDGetChildByName(panel, "image_singleBg")
		panelSingleBg:loadTexture(string.format("BG_zzsds_0%d.png", i), ccui.TextureResType.plistType)
		local panelSingleBtn = SoraDGetChildByName(panel, "btn_click")
		panelSingleBtn:setTag(i)
		local panelSingleText = SoraDGetChildByName(panel, "text_title")
		local commonStr = ""
		if i == 1 then
			commonStr = i18n("christmas_tree_text_01")
		elseif i == 2 then
			commonStr = i18n("christmas_tree_text_02")
		elseif i == 3 then
			commonStr = i18n("christmas_tree_text_03")
		end
		panelSingleText:setString(commonStr)
	end
end
function christmasTreeProductionView:questClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.CHRISTMAS_TREE_PRODUCTION)
	end
end
function christmasTreeProductionView:enterClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button:getTag() == 1 then
			SoraDCreatePanel("christmasTreeMakingView"):show()
		elseif button:getTag() == 2 then
			SoraDCreatePanel("recycleDecorationsView"):show()
		elseif button:getTag() == 3 then
			SoraDCreatePanel("allianceChristmasTreeView"):show()
		end
	end
end
function christmasTreeProductionView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CHRISTMAS_TREE_PRODUCTION) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return christmasTreeProductionView
