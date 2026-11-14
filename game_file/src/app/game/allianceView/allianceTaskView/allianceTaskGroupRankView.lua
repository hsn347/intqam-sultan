local gametop = gModuleMgr.getObject("gametop")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local publicRead = include("publicRead")
local allianceTaskGroupRankView = class("allianceTaskGroupRankView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceTaskGroupRankView")
	end
	if type(target) == "string" then
		return SoraDCreateTouchPanel(target)
	end
	return target
end)
function allianceTaskGroupRankView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_3593"))
	self.nodeCenter = SoraDGetChildByName(self, "Center_Node")
	self.Center_Panel_main = SoraDGetChildByName(self, "Center_Panel_main")
	self.Size_Tile_bg = SoraDGetChildByName(self, "Size_Tile_bg")
	self.frame_king_line5_1 = SoraDGetChildByName(self, "frame_king_line5_1")
	self.frame_king_line5_2 = SoraDGetChildByName(self, "frame_king_line5_2")
	self.Image_baseBg = SoraDGetChildByName(self, "Image_baseBg")
	self.frame_activity_lace_02_1 = SoraDGetChildByName(self, "frame_activity_lace_02_1")
	self.frame_activity_lace_02_2 = SoraDGetChildByName(self, "frame_activity_lace_02_2")
	self.frame_battlefield_cloth_01_6 = SoraDGetChildByName(self, "frame_battlefield_cloth_01_6")
	self.frame_battlefield_cloth_01_5 = SoraDGetChildByName(self, "frame_battlefield_cloth_01_5")
	self.Node_title = SoraDGetChildByName(self, "Node_title")
	self.img_head = SoraDGetChildByName(self, "img_head")
	self.text_title = SoraDGetChildByName(self, "text_title")
	self.frame_recharge_continue_fire_01_7 = SoraDGetChildByName(self, "frame_recharge_continue_fire_01_7")
	self.frame_recharge_continue_fire_01_7_0 = SoraDGetChildByName(self, "frame_recharge_continue_fire_01_7_0")
	self.frame_recharge_continue_fire_01_8 = SoraDGetChildByName(self, "frame_recharge_continue_fire_01_8")
	self.frame_recharge_continue_fire_01_8_0 = SoraDGetChildByName(self, "frame_recharge_continue_fire_01_8_0")
	self.text_tip = SoraDGetChildByName(self, "text_tip")
	self.Image_4 = SoraDGetChildByName(self, "Image_4")
	self.Image_3 = SoraDGetChildByName(self, "Image_3")
	self.Size_ScrollView_Rewards = SoraDGetChildByName(self, "Size_ScrollView_Rewards")
	self.Panel_reward = SoraDGetChildByName(self, "Panel_reward")
	self.item_bg_r = SoraDGetChildByName(self, "item_bg_r")
	self.item_bg_l = SoraDGetChildByName(self, "item_bg_l")
	self.img_title_bg = SoraDGetChildByName(self, "img_title_bg")
	self.text_item_title = SoraDGetChildByName(self, "text_item_title")
	self.item_single = SoraDGetChildByName(self, "item_single")
	self.item_single_quality = SoraDGetChildByName(self, "item_single_quality")
	self.item_single_num_bg = SoraDGetChildByName(self, "item_single_num_bg")
	self.item_single_icon = SoraDGetChildByName(self, "item_single_icon")
	self.item_single_num = SoraDGetChildByName(self, "item_single_num")
	self.item_single_show = SoraDGetChildByName(self, "item_single_show")
	self.item_single_name = SoraDGetChildByName(self, "item_single_name")
	self.ccs_bg:setSize(cc.size(560, display.height - 260))
	self.nodeCenter:setPositionY(self.nodeCenter:getPositionY() - (display.height - 960) / 2)
	self.text_tip:setPositionY(self.text_tip:getPositionY() + display.height - 960)
	self.Size_ScrollView_Rewards:setContentSize(cc.size(530, display.height - 377))
	self.Panel_reward:setSwallowTouches(false)
	self.Size_ScrollView_Rewards:setClippingEnabled(true)
	self:init()
end
function allianceTaskGroupRankView:addPanelHeight(panelReward, addedHeight)
	panelReward:setContentSize(cc.size(panelReward:getContentSize().width, panelReward:getContentSize().height + addedHeight))
	local img_title_bg = SoraDGetChildByName(panelReward, "img_title_bg")
	img_title_bg:setPositionY(img_title_bg:getPositionY() + addedHeight)
	local item_bg_l = SoraDGetChildByName(panelReward, "item_bg_l")
	local item_bg_r = SoraDGetChildByName(panelReward, "item_bg_r")
	item_bg_l:setContentSize(cc.size(item_bg_l:getContentSize().width, item_bg_l:getContentSize().height + addedHeight))
	item_bg_r:setContentSize(cc.size(item_bg_r:getContentSize().width, item_bg_r:getContentSize().height + addedHeight))
end
function allianceTaskGroupRankView:init(data)
	self.text_tip:setString(i18n("common_text_3594"))
	local userMissionData = playerMobilizationCtrl:getPersonalMissionData()
	self.tblPanelRewards, _ENV, self.matchLev = userMissionData and userMissionData.matchlev or 1, userMissionData and userMissionData.matchlev or 1, userMissionData and userMissionData.matchlev or 1
	local numOfRank = 5
	local heightPanel = 210
	local totalHeight = 0
	local heightItem = 127
	local numColOfItem = 5
	for i = 1, numOfRank do
		local panelReward
		if i == 1 then
			panelReward = self.Panel_reward
		else
			panelReward = self.Panel_reward:clone()
			panelReward:addTo(self.Size_ScrollView_Rewards)
		end
		_ENV = i18n("common_text_3594")
		i18n("common_text_3594").num = i
		SoraDGetChildByName(panelReward, "text_item_title"):setString(i18n("common_text_617", i18n("common_text_3594")))
		table.insert(self.tblPanelRewards, panelReward)
	end
	for i = 1, numOfRank do
		local panelReward = self.tblPanelRewards[i]
		local awardListSize = #self:getAwardList(self.matchLev, i) / 2
		local addedHeight = (math.floor((awardListSize + numColOfItem - 1) / numColOfItem) - 1) * heightItem
		print("#awardListSize = ", awardListSize, "addedHeight = ", addedHeight)
		if addedHeight < 0 then
			addedHeight = 0
		end
		panelReward:setContentSize(cc.size(panelReward:getContentSize().width, panelReward:getContentSize().height + addedHeight))
		print("panelReward:getContentSize().height = ", panelReward:getContentSize().height)
		totalHeight = totalHeight + panelReward:getContentSize().height + 10
		panelReward:getChildByName("Node_single_award"):setPositionY(panelReward:getContentSize().height - 4)
	end
	print("totalHeight = ", totalHeight)
	local accuHeight = -120
	for i = 1, numOfRank do
		local panelReward = self.tblPanelRewards[i]
		accuHeight = accuHeight + panelReward:getContentSize().height
		panelReward:setPositionX(0)
		panelReward:setPositionY(totalHeight - accuHeight - 120)
	end
	for i = 1, numOfRank do
		local awardList = self:getAwardList(self.matchLev, i)
		local awardListSize = #awardList / 2
		local panelReward = self.tblPanelRewards[i]
		local totalItemHeight = math.floor((awardListSize + numColOfItem - 1) / numColOfItem) * heightItem
		for j = 1, #awardList / 2 do
			local itemId = awardList[2 * j - 1]
			local itemNum = awardList[2 * j]
			local itemSingle
			if j == 1 then
				itemSingle = panelReward:getChildByName("item_single")
			else
				itemSingle = panelReward:getChildByName("item_single"):clone()
				itemSingle:setName("item_single" .. j)
				itemSingle:addTo(panelReward)
			end
			local xIndex = j - (math.floor((j + numColOfItem - 1) / numColOfItem) - 1) * numColOfItem
			if SoraDFIsRA() then
				itemSingle:setPositionX(510 - (55 + (xIndex - 1) * 100))
			else
				itemSingle:setPositionX(55 + (xIndex - 1) * 100)
			end
			local itemY = totalItemHeight - math.floor((j + numColOfItem - 1) / numColOfItem) * heightItem
			itemSingle:setPositionY(itemY + 90)
			itemSingle:getChildByName("item_single_quality"):loadTexture(publicRead.getBg(itemId), ccui.TextureResType.plistType)
			itemSingle:getChildByName("item_single_icon"):loadTexture(publicRead.getIcon(itemId), ccui.TextureResType.plistType)
			itemSingle:getChildByName("item_single_num"):setString(itemNum)
			itemSingle:getChildByName("item_single_name"):setString(publicRead.getName(itemId))
			local item_single_show = itemSingle:getChildByName("item_single_show")
			item_single_show:setTouchEnabled(true)
			item_single_show:addTouchEventListener(handler(self, self.onClick_Button_show))
			item_single_show.itemId = itemId
		end
	end
	local newScrollH = totalHeight
	local scrollInner = self.Size_ScrollView_Rewards:getInnerContainer()
	local scrollH = self.Size_ScrollView_Rewards:getContentSize().height
	if newScrollH < scrollH then
		newScrollH = scrollH
	end
	print("newScrollH = ", newScrollH)
	self.Size_ScrollView_Rewards:setInnerContainerSize(cc.size(scrollInner:getContentSize().width, newScrollH))
	self.Size_ScrollView_Rewards:scrollToTop(0.01, false)
end
function allianceTaskGroupRankView:getAwardList(matchLev, rank)
	local rankAwardCfg = mobilizationltCtrl:getRankAward()
	for i, v in ipairs(rankAwardCfg) do
		if v.match_lev == matchLev and rank >= v.rank[1] and rank <= v.rank[2] then
			return v.reward
		end
	end
	mobilizationltCtrl = (for generator)
	return ipairs(rankAwardCfg)
end
function allianceTaskGroupRankView:initItem(itemNode, itemId, itemNum)
end
function allianceTaskGroupRankView:onMessageListener()
end
function allianceTaskGroupRankView:onClick_Button_close(sender, event)
	print("--------")
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		print("关闭----")
		SoraDPlaySound("uicontrol", 1)
		self:close(sender, event)
	end
end
function allianceTaskGroupRankView:onClick_item_single_show(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
	end
end
function allianceTaskGroupRankView:onClick_Button_show(sender, event)
	if event == ccui.TouchEventType.began then
		self:openItemInfo(sender.itemId, sender)
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
		self:closeItemInfo()
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:closeItemInfo()
	end
end
function allianceTaskGroupRankView:openItemInfo(id, sender)
	_UPVALUE0_ = nil
	;(nil).id = id
	;(nil).item = sender
	self:openItemInfoMsg(nil)
end
function allianceTaskGroupRankView:closeItemInfo()
	self:closeItemInfoMsg()
end
function allianceTaskGroupRankView:openItemInfoMsg(data)
	local itemID = data.id
	local item = data.item
	if self.itemTips == nil then
		self.itemTips = SoraDCreatePanel("commonItemTips")
		self.itemTips:setPositionY(50)
		self.itemTips:addTo(self)
		self.itemTips:setLocalZOrder(10)
		self.itemTips:setVisible(false)
	end
	local worldPos = item:convertToWorldSpace(cc.p(0, 0))
	local nodePos = self:convertToNodeSpace(worldPos)
	local deltaTipX = 0
	if SoraDFIsRA() then
		deltaTipX = 0
	else
		deltaTipX = -280
	end
	if nodePos.x > 300 then
		self.itemTips:setPositionX(nodePos.x + 15 + deltaTipX)
	else
		self.itemTips:setPositionX(nodePos.x + 325 + deltaTipX)
	end
	self.itemTips:setPositionY(nodePos.y + 200)
	self.itemTips:setVisible(true)
	self.itemTips:initData(itemID)
end
function allianceTaskGroupRankView:closeItemInfoMsg(data)
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
return allianceTaskGroupRankView
