local activity_9001619_Read = include("activity_9001619_Read")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001619_Ctrl = gametop.playertop_:getModule("activity_9001619_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001619_AwardPreviewViewPanel = class("Activity_9001619_AwardPreviewViewPanel", baseFguiPanel)
function Activity_9001619_AwardPreviewViewPanel:ctor(...)
	Activity_9001619_AwardPreviewViewPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001619_AwardPreviewViewPanel:ctor", self.viewName)
end
function Activity_9001619_AwardPreviewViewPanel:onInit()
	print("=======Activity_9001619_AwardPreviewViewPanel:onInit")
	self.ccs_bg = SoraDGetChildByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitle(i18n("decrypt_text_03"))
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.txtTips = SoraDGetChildByName(self, "Text_tips")
	self.txtTips:setString(i18n("starlight_text_07"))
	self.layout = SoraDGetChildByName(self, "layout")
	self.nodeTitleNormal = SoraDGetChildByName(self, "Node_title_normal")
	self.nodeTitleNormal:setVisible(false)
	self.singleGold = SoraDGetChildByName(self, "Node_single_gold")
	self.singleGold:setVisible(false)
	self.single = SoraDGetChildByName(self, "Node_single")
	self.single:setVisible(false)
	self.singles, _ENV = self.single.setVisible, self.single.setVisible
	self.scroll = SoraDGetChildByName(self, "ScrollView_award")
	self:initData()
end
function Activity_9001619_AwardPreviewViewPanel:onShow()
	print("=======Activity_9001619_AwardPreviewViewPanel:onShow")
end
function Activity_9001619_AwardPreviewViewPanel:initData(data)
	self.itemList, activity_9001619_Read = nil, nil
	local insertAward = function(itemData, awardType)
		local awardList = self.itemList[awardType]
		if nil == awardList then
			awardList, self = nil, nil
			self.itemList[awardType] = awardList
		end
		awardList[#awardList + 1] = itemData
	end
	if not activity_9001619_Read:getCombCfg() then
		local activity_9001619_Read, awardShowList = activity_9001619_Read:getCombCfg(), activity_9001619_Read:getCombCfg()
	end
	for _, v in ipairs(awardShowList) do
		local awardType = v.type or 1
		insertAward(v, awardType)
	end
	self:initScrollList()
end
function Activity_9001619_AwardPreviewViewPanel:initScrollList()
	self.scrollH = 450
	self.offsetY = nil
	self:updateScrollData()
	self:updateScrollPos()
end
local TITLE_HEIGHT = 40
local SCROLL_ITEM_HEIGHT = 80
local SCROLL_ITEM_HEIGHT_GOLD = 210
function Activity_9001619_AwardPreviewViewPanel:updateScrollPos()
	self.layout:ensureBoundsCorrect()
end
function Activity_9001619_AwardPreviewViewPanel:updateScrollData()
	for k, v in ipairs(self.itemList) do
		self:updateScrollData_imp(k, v)
	end
	dump(self.singles, "self.singles")
	for i, v in ipairs(self.singles) do
		v:fixChildrenPos(true)
	end
end
function Activity_9001619_AwardPreviewViewPanel:updateScrollData_imp(awardType, itemInfo)
	if awardType ~= 1 then
		self:getSingle_Title(awardType)
	end
	for _, v in ipairs(itemInfo) do
		self:getSingle_AwardPanel(awardType, v)
	end
end
function Activity_9001619_AwardPreviewViewPanel:createSingle(node)
	if node:isVisible() then
		local single = node:clone()
		single:setAnchorPoint(0.5, 0.5)
		single:addTo(self.nodeReward)
		single:setGroup(self.layout)
		single:setVisible(true)
		return single
	else
		node:setVisible(true)
		return node
	end
end
function Activity_9001619_AwardPreviewViewPanel:getSingle_Title(awardType)
	local singleNode
	singleNode = self.nodeTitleNormal
	local single = self:createSingle(singleNode)
	local strTitle = activity_9001619_Read:getAwardNmae(awardType)
	local txtScoreTitle = SoraDGetChildByName(single, "Text_score_title")
	txtScoreTitle:setString(strTitle)
	self.scrollH = self.scrollH + TITLE_HEIGHT
	return single
end
function Activity_9001619_AwardPreviewViewPanel:getSingle_AwardPanel(awardType, itemInfo)
	local singleNode, itemH
	if awardType == 1 then
		singleNode = self.singleGold
		itemH = SCROLL_ITEM_HEIGHT_GOLD
	else
		singleNode = self.single
		itemH = SCROLL_ITEM_HEIGHT
	end
	local single = self:createSingle(singleNode)
	table.insert(self.singles, single)
	self:initSingle(single, itemInfo)
	self.scrollH = self.scrollH + itemH
end
function Activity_9001619_AwardPreviewViewPanel:initSingle(node, lampInfo)
	if lampInfo then
		do
			local tableItem = SoraDGetChildsArrayByName(node, "CCS_starRhapsodyLamp_award_", 3, 1, true)
			for i, v in ipairs(tableItem) do
				if lampInfo.colorComb[i] then
					v:setLampColor(lampInfo.colorComb[i])
				end
			end
		end
		do
			local tableItem = SoraDGetChildsArrayByName(node, "CCS_commonItemAward_", 4, 1, true)
			for i, v in ipairs(tableItem) do
				local item = lampInfo.reward[i]
				if item then
					v:setVisible(true)
					v:initData(item.id, item.count)
				else
					v:setVisible(false)
				end
			end
		end
		local nodeMask = SoraDGetChildByName(node, "Node_mask")
		local hasGet = activity_9001619_Ctrl:hasGetReward(lampInfo.combID)
		nodeMask:setVisible(hasGet)
	end
end
return Activity_9001619_AwardPreviewViewPanel
