local starRhapsodyRead = include("starRhapsodyRead")
local gametop = gModuleMgr.getObject("gametop")
local starRhapsodyCtrl = gametop.playertop_:getModule("starRhapsodyCtrl")
local starRhapsodyAwardPreviewView = class("starRhapsodyAwardPreviewView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("starRhapsodyAwardPreviewView")
	end
	return target
end)
function starRhapsodyAwardPreviewView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("decrypt_text_03"))
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.txtTips = SoraDGetChildByName(self, "Text_tips")
	self.txtTips:setString(i18n("starlight_text_07"))
	SoraDSetTextWidthHeight(self.txtTips, cc.size(520, 60))
	self.nodeTitleNormal = SoraDGetChildByName(self, "Node_title_normal")
	self.nodeTitleNormal:setVisible(false)
	self.nodeTitleGold = SoraDGetChildByName(self, "Node_title_gold")
	self.nodeTitleGold:setVisible(false)
	self.singleGold = SoraDGetChildByName(self, "Node_single_gold")
	self.singleGold:setVisible(false)
	self.single = SoraDGetChildByName(self, "Node_single")
	self.single:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "ScrollView_award")
	self:initData()
end
function starRhapsodyAwardPreviewView:initData(data)
	self.itemList, starRhapsodyRead = nil, nil
	local insertAward = function(itemData, awardType)
		local awardList = self.itemList[awardType]
		if nil == awardList then
			awardList, self = nil, nil
			self.itemList[awardType] = awardList
		end
		awardList[#awardList + 1] = itemData
	end
	if not starRhapsodyRead:getCombCfg() then
		local starRhapsodyRead, awardShowList = starRhapsodyRead:getCombCfg(), starRhapsodyRead:getCombCfg()
	end
	for _, v in ipairs(awardShowList) do
		local awardType = v.type or 1
		insertAward(v, awardType)
	end
	self:initScrollList()
end
function starRhapsodyAwardPreviewView:initScrollList()
	self.scrollH = 0
	self.offsetY = nil
	self:updateScrollData()
	self:updateScrollPos()
end
local TITLE_HEIGHT = 40
local SCROLL_ITEM_HEIGHT = 80
local SCROLL_ITEM_HEIGHT_GOLD = 210
function starRhapsodyAwardPreviewView:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = self.scrollH + 10
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeReward:setPositionY(sH)
end
function starRhapsodyAwardPreviewView:updateScrollData()
	for k, v in ipairs(self.itemList) do
		self:updateScrollData_imp(k, v)
	end
end
function starRhapsodyAwardPreviewView:updateScrollData_imp(awardType, itemInfo)
	self:getSingle_Title(awardType)
	for _, v in ipairs(itemInfo) do
		self:getSingle_AwardPanel(awardType, v)
	end
end
function starRhapsodyAwardPreviewView:createSingle(node)
	if node:isVisible() then
		local single = node:clone()
		single:addTo(self.nodeReward)
		single:setVisible(true)
		return single
	else
		node:setVisible(true)
		return node
	end
end
function starRhapsodyAwardPreviewView:getSingle_Title(awardType)
	local singleNode
	if awardType == 1 then
		singleNode = self.nodeTitleGold
	else
		singleNode = self.nodeTitleNormal
	end
	local single = self:createSingle(singleNode)
	local strTitle = starRhapsodyRead:getAwardNmae(awardType)
	local txtScoreTitle = SoraDGetChildByName(single, "Text_score_title")
	txtScoreTitle:setString(strTitle)
	single:setPositionY(-self.scrollH)
	self.scrollH = self.scrollH + TITLE_HEIGHT
	return single
end
function starRhapsodyAwardPreviewView:getSingle_AwardPanel(awardType, itemInfo)
	local singleNode, itemH
	if awardType == 1 then
		singleNode = self.singleGold
		itemH = SCROLL_ITEM_HEIGHT_GOLD
	else
		singleNode = self.single
		itemH = SCROLL_ITEM_HEIGHT
	end
	local single = self:createSingle(singleNode)
	single:setPositionY(-self.scrollH)
	self:initSingle(single, itemInfo)
	self.scrollH = self.scrollH + itemH
end
function starRhapsodyAwardPreviewView:initSingle(node, lampInfo)
	if lampInfo then
		do
			local tableItem = SoraDGetChildsArrayByName(node, "CCS_starRhapsodyLamp_award_", 3, 1, true, true)
			for i, v in ipairs(tableItem) do
				if lampInfo.colorComb[i] then
					v:setLampColor(lampInfo.colorComb[i])
				end
			end
		end
		do
			local tableItem = SoraDGetChildsArrayByName(node, "CCS_commonItemAward_", 4, 1, true, true)
			for i, v in ipairs(tableItem) do
				local item = lampInfo.reward[i]
				if item then
					v:setOwnView(self)
					v:setVisible(true)
					v:setBaseScale(1.0)
					v:initData(item.id, item.count)
				else
					v:setVisible(false)
				end
			end
		end
		local nodeMask = SoraDGetChildByName(node, "Node_mask")
		local hasGet = starRhapsodyCtrl:hasGetReward(lampInfo.combID)
		nodeMask:setVisible(hasGet)
	end
end
return starRhapsodyAwardPreviewView
