local itemDesRead = include("itemDesRead")
local jumpDesRead = include("jumpDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local bonfireGetWayView = class("bonfireGetWayView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("collectSalaryGetWay")
	end
	return target
end)
function bonfireGetWayView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.ccs_bg:setTitleName(i18n("common_text_4342"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingleNode))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingleNode))
end
function bonfireGetWayView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.itemNumBack))
end
function bonfireGetWayView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.BONFIRE_NIGHT_BANQUET) then
		self:removeFromParent()
	end
end
function bonfireGetWayView:itemNumBack()
	if backpackCtrl:getItemCount(299201) <= 0 and self.itemID then
		self:initData(self.itemID)
	end
end
function bonfireGetWayView:initData(itemID, otherData)
	local data = itemDesRead.getOutput(itemID)
	local itemDesRead, infoData = itemID, itemID
	for i, v in ipairs(data) do
		local tmp = jumpDesRead.getCfg(v)
		table.insert(infoData, tmp)
	end
	if otherData and otherData.isOrangItem and backpackCtrl:getItemCount(299201) > 0 and 0 < otherData.needNum then
		self.needNum = math.min(backpackCtrl:getItemCount(299201), otherData.needNum)
		itemDesRead = otherData.needNum
		otherData.needNum.sourceid = 0
		otherData.needNum.icon = "2992.png"
		otherData.needNum.des = "item_name_299201"
		otherData.needNum.isItemUse = true
		table.insert(infoData, otherData.needNum)
		self.itemID = itemID
	end
	self.isNewWarmHeart = otherData and otherData.isNewWarmHeart
	self.scroll:updateScrollView(cc.size(533, 130), infoData, 1)
end
function bonfireGetWayView:createSingleNode()
	local single = self.singleNode:clone()
	return single
end
function bonfireGetWayView:refreshSingleNode(target, data, otherData)
	local button = SoraDGetChildByName(target, "Button_Go")
	SoraDAutoSizeButtonTextByContent(button)
	local textName = SoraDGetChildByName(target, "Text_WayName")
	local icon = SoraDGetChildByName(target, "Image_Icon")
	dump(data, "data=--bonfireGetWayView", 10)
	textName:setString(i18n(data.des))
	if data.sourceid == 34 then
		_ENV = i18n(data.des)
		i18n(data.des).num = 1
		textName:setString(i18n(data.des, i18n(data.des)))
	end
	SoraDGetAutoHeightLabel(textName, 200)
	icon:loadTexture(data.icon, ccui.TextureResType.plistType)
	button:setTag(data.sourceid)
	if data.sourceid == 29 then
		icon:setScale(0.85)
	else
		icon:setScale(1)
	end
	if data.isItemUse then
		button:loadTextures("btn_green_normal_01.png", "btn_green_normal_02.png", "", ccui.TextureResType.plistType)
		button:setTitleText(i18n("common_text_314"))
		SoraDGetChildByName(target, "Text_Num"):setString(string.formatnumberthousands(backpackCtrl:getItemCount(299201)))
	else
		button:loadTextures("btn_yellow_normal_01.png", "btn_yellow_normal_02.png", "", ccui.TextureResType.plistType)
		button:setTitleText(i18n("common_text_477"))
		SoraDGetChildByName(target, "Text_Num"):setString("")
		local activityID
		if data.sourceid == 13 then
			activityID = gActivityTimeActivityID.DEVIL_VALLEY_ACTIVITY
		elseif data.sourceid == 31 then
			activityID = gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY
		elseif data.sourceid == 32 then
			activityID = gActivityTimeActivityID.EQUIP_ACTIVITY
		end
		if activityID and not clientEventMgr.judgeIsOpen(activityID) then
			button:setTitleText(i18n("common_text_2486"))
		end
	end
	button:addTouchEventListener(handler(self, self.btnClickJump))
end
function bonfireGetWayView:btnClickJump(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button:getTitleText() == i18n("common_text_2486") then
			SoraDShowMsgTip(i18n("common_text_2486"))
			return
		end
		local sourceId = button:getTag()
		local guide = jumpDesRead.getGuide(sourceId)
		dump(guide, "guide data", 10)
		print("sourceId======", sourceId)
		if sourceId == 32 then
			clientEventMgr.singleClickEvent(gActivityTimeActivityID.EQUIP_ACTIVITY)
			return
		elseif sourceId == 34 then
			SoraDRemoveAllPanelFromManager()
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = 10
				;(10).rechargeID = 14029
				uiManager:show("rechargeView", 10)
			else
				local panel = SoraDCreatePanel("rechargeView")
				panel:expect2SelectTabEx(gRechargeCenterCategory.HOTGIFT, 14029)
				panel:show()
			end
			return
		elseif sourceId == 37 then
			_ENV = gRechargeCenterCategory.HOTGIFT
			gRechargeCenterCategory.HOTGIFT.isTool = true
			uiManager:show("militaryRankSkillView", gRechargeCenterCategory.HOTGIFT)
			return
		elseif sourceId == 38 then
			if self.isNewWarmHeart then
				local panel = SoraDCreatePanel("newWarmHeartFastBuyView")
				panel:show()
			else
				local panel = SoraDCreatePanel("warmHeartFastBuyView")
				panel:show()
			end
			return
		elseif sourceId == 0 then
			_ENV = gRechargeCenterCategory.HOTGIFT
			gRechargeCenterCategory.HOTGIFT.itemID = 299201
			gRechargeCenterCategory.HOTGIFT.selectedItemID = self.itemID
			gRechargeCenterCategory.HOTGIFT.curCount = self.needNum
			uiManager:show("CommonSelectResourceBox", gRechargeCenterCategory.HOTGIFT)
			return
		elseif sourceId == 13 then
			clientEventMgr.singleClickEvent(gActivityTimeActivityID.DEVIL_VALLEY_ACTIVITY)
			return
		elseif sourceId == 31 then
			clientEventMgr.singleClickEvent(gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY)
			return
		end
		if guide.id then
			SoraDRemoveAllPanelFromManager()
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			local ret = mildGuideManager:starMildByNewPlayerQuestID(guide.id, guide)
			return ret
		else
			SoraDJumpBySourceId(sourceId)
			self:closePanel()
			return false
		end
	end
end
return bonfireGetWayView
