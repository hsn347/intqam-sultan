local GridScrollView = include("GridScrollView")
local masteryViewSingleItem = include("masteryViewSingleItem")
local specializationRead = include("specializationRead")
local MASTERY_STATE = specializationRead.MASTERY_STATE
local cityCtrl = SoraDGetCtrl("cityCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local cityBuildConstDef = include("cityBuildConstDef")
local masteryMainView = class("masteryMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("masteryMainView")
	end
	return target
end)
function masteryMainView:onExitPanel()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
	SoraDSendMessage(nil)
end
function masteryMainView:ctor()
	self.isHideCurrentSceneView = true
	self.needBack = true
	self:initMasteryList()
	self:initWidget()
	SoraDAddMessage(self, "MESSAGE_MASTERY_VIEW_REFRESH", handler(self, self.msgUpdateView))
end
function masteryMainView:onEnterPanel()
	self:initData()
end
function masteryMainView:msgUpdateView(target, event)
	self:initMasteryList()
	self:initData()
	if "unlock" == event.name then
		local needBack = self.needBack
		SoraDRemoveAllPrePanelFromManager(self)
		local panel = SoraDCreatePanel("masteryLockPopView")
		_ENV = nil
		;(nil).bid = event.bid
		;(nil).needBack = needBack
		panel:initData(nil)
		panel:show()
	end
end
function masteryMainView:initWidget(...)
	local ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_build")
	self.ccs_title = ccs_title
	ccs_title:setTitle(i18n("specialization_text_03"))
	GridScrollView = i18n("specialization_text_03")
	i18n("specialization_text_03")[1] = "Button_help"
	local Button_help = SoraDGetChildByFullPath(ccs_title, i18n("specialization_text_03"))
	Button_help:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.BUILD_MASTERY)
		end
	end)
	local root = self._ccsView
	GridScrollView = i18n("specialization_text_03")
	i18n("specialization_text_03")[1] = "Node_single_item"
	self.singleItem = SoraDGetChildByFullPath(root, i18n("specialization_text_03"))
	GridScrollView = i18n("specialization_text_03")
	i18n("specialization_text_03")[1] = "Top_Size_ScrollView_build"
	self.scroll = SoraDGetChildByFullPath(root, i18n("specialization_text_03"))
	self.scroll = GridScrollView.new(self.scroll)
	GridScrollView = i18n("specialization_text_03")
	i18n("specialization_text_03")[1] = "Top_Node"
	self.scroll:addTo(SoraDGetChildByFullPath(root, i18n("specialization_text_03")))
	self.scroll:setPositionY(-127)
	_ENV = self.scroll.setPositionY
	self.scroll.setPositionY.col = 2
	self.scroll.setPositionY.left = 160
	self.scroll.setPositionY.w = 169
	self.scroll.setPositionY.top = 17
	local self.scroll.setPositionY.h, margin = 18, self.scroll.setPositionY
	if fgui.GRoot.inst:getHeight() / fgui.GRoot.inst:getWidth() < 1.75 then
		_ENV = fgui.GRoot.inst:getHeight() / fgui.GRoot.inst:getWidth()
		;(fgui.GRoot.inst:getHeight() / fgui.GRoot.inst:getWidth()).col = 2
		;(fgui.GRoot.inst:getHeight() / fgui.GRoot.inst:getWidth()).left = 160
		;(fgui.GRoot.inst:getHeight() / fgui.GRoot.inst:getWidth()).w = 169
		;(fgui.GRoot.inst:getHeight() / fgui.GRoot.inst:getWidth()).top = 127
		margin, (fgui.GRoot.inst:getHeight() / fgui.GRoot.inst:getWidth()).h = fgui.GRoot.inst:getHeight() / fgui.GRoot.inst:getWidth(), 18
	end
	self.scroll:init(margin, 0, handler(self, self.createSingleItem), handler(self, self.refreshSingleItem))
	_UPVALUE2_ = margin
	margin[1] = "Top_Node"
	margin[2] = "Text_1"
	SoraDGetChildByFullPath(root, margin):setString(i18n("specialization_text_04"))
	_UPVALUE2_ = i18n("specialization_text_04")
	i18n("specialization_text_04")[1] = "Top_Node"
	i18n("specialization_text_04")[2] = "Image_left"
	local Image_left = SoraDGetChildByFullPath(root, i18n("specialization_text_04"))
	_UPVALUE2_ = "Top_Node"
	;("Top_Node")[1] = "Top_Node"
	;("Top_Node")[2] = "Image_right"
	local Image_right = SoraDGetChildByFullPath(root, "Top_Node")
	Image_left:setContentSize(cc.size(display.height - 72, Image_left:getContentSize().height))
	Image_right:setContentSize(cc.size(display.height - 72, Image_left:getContentSize().height))
end
function masteryMainView:createSingleItem()
	local item = masteryViewSingleItem.new(self.singleItem:clone())
	item:setClickBuildHandler(handler(self, self.clickBuildCallback))
	return item
end
function masteryMainView:clickBuildCallback(index)
	local mastery = self.masteryList[index]
	local bid = mastery.building
	local __, iid = cityCtrl:getBuildMaxLv(bid)
	local buildCell = cityCtrl:getBuildCell(bid, iid)
	if not buildCell and bid ~= cityBuildConstDef.fixedBuildDef.Mastery then
		GLOBAL_BUILD_PRE_BID = bid
		cityCtrl = bid
		bid.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
		bid.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD_TIP_HAND
		bid.bid = bid
		bid.iid = nil
		bid.isRecover = true
		SoraDSendMessage(bid)
		SoraDRemoveAllPrePanelFromManager(self)
	else
		SoraDRemoveAllPrePanelFromManager(self)
		local mainCityFunctions = include("mainCityFunctions")
		mainCityFunctions.masteryJumpToDetailView(bid, iid, true)
	end
end
function masteryMainView:refreshSingleItem(item, index)
	item:setLocalZOrder(index)
	local mastery = self.masteryList[index]
	_UPVALUE0_ = nil
	;(nil).index = index
	;(nil).state = mastery and mastery.state
	;(nil).bid = mastery and mastery.building or 0
	;(nil).mid = mastery and mastery.mastery
	item:initData(nil)
end
function masteryMainView:initData(...)
	self.scroll:updateNum(math.ceil(#self.masteryList / 2) * 2)
end
function masteryMainView:initMasteryList(...)
	local masteryList = specializationRead.getMasteryList()
	local queue = queueCtrl:queryQueue(gQueueTypeDef.build_mastery)
	local upgradingBid = queue and queue.data.bid or 0
	for i, v in ipairs(masteryList) do
		v.state, v.sortWeight = specializationRead.getMasteryState(v.building, v.mastery)
		if upgradingBid == v.building then
			v.sortWeight = 0
		end
	end
	table.sort(masteryList, function(a, b)
		if a.sortWeight ~= b.sortWeight then
			return a.sortWeight < b.sortWeight
		else
			return a.order < b.order
		end
	end)
	self.masteryList = masteryList
end
function masteryMainView:doDelayAction(mid)
	local buildLogic = include("buildLogic")
	local bid = specializationRead.getBuildID(mid)
	if buildLogic.checkDemolishQueue(bid) then
		SoraDShowMsgTip(i18n("specialization_tips_03"))
	else
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		cityCtrl:sendReqMasteryUnlock(mid)
		self.needBack = false
	end
end
function masteryMainView:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_unlock" then
		for i, v in ipairs(self.scroll.cellList) do
			if v.idx == 1 then
				return SoraDGetChildByName(v, "Image_build")
			end
		end
	elseif itemName == "Button_close" then
		return SoraDGetChildByName(self.ccs_title, "Button_close")
	end
end
return masteryMainView
