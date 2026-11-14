local remainsWarltCtrl = include("remainsWarltCtrl")
local remainsWarRead = include("remainsWarRead")
local remainsWarRewardSeasonView = class("remainsWarRewardSeasonView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
_ENV = "remainsWarRewardSeasonView"
;("remainsWarRewardSeasonView").awardTitle = 1
;("remainsWarRewardSeasonView").awardTitleStage = 2
;("remainsWarRewardSeasonView").awardScroll = 3
local ("remainsWarRewardSeasonView").awardItem, nodeType = 4, "remainsWarRewardSeasonView"
function remainsWarRewardSeasonView:ctor()
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.nodeTitle = SoraDGetChildByName(self, "Node_title")
	self.nodeTitle:setVisible(false)
	self.single = SoraDGetChildByName(self, "Node_single")
	self.single:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "ScrollView_award")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.listNode, _ENV, self.scrollItems, _ENV = self.scroll.addEventListener, self.scroll.addEventListener, self.scroll.addEventListener, self.scroll.addEventListener
	for _, v in pairs(nodeType) do
		self.listNode[v], _ENV = handler(self, self.scrollEventCallBack)
	end
	self.mvp = SoraDGetChildByName(self, "Text_mvp")
	self.mvp:setString(i18n("remains_text_205"))
	SoraDSetTextWidthHeight(self.mvp, cc.size(580, 60))
end
function remainsWarRewardSeasonView:init()
	self.rewardStrenght = remainsWarltCtrl:getRewarsStrenght()
	self.rewardStage = remainsWarltCtrl:getRewarsStage()
	self:initScrollList()
end
local TITLE_HEIGHT = 50
local SCROLL_ITEM_HEIGHT = 120
function remainsWarRewardSeasonView:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = self.scrollH + 10
	local sH = math.max(sSize.height, listHeight)
	local posY = sH
	for _, v in ipairs(self.scrollItems) do
		if v.nodeType == nodeType.awardTitle or v.nodeType == nodeType.awardTitleStage then
			posY = posY - TITLE_HEIGHT
		elseif v.nodeType == nodeType.awardScroll then
			posY = posY - SCROLL_ITEM_HEIGHT
		end
		v.posY = posY
	end
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeReward:setPositionY(0)
end
function remainsWarRewardSeasonView:updateScrollDataStrenght_imp(danID, danInfo)
	_ENV = nil
	;(nil).nodeType = nodeType.awardTitle
	;(nil).posY = 0
	table.insert(self.scrollItems, nil)
	self.scrollH = self.scrollH + TITLE_HEIGHT
	do
		local _ENV, reward = self.scrollH + TITLE_HEIGHT, danInfo or self.scrollH + TITLE_HEIGHT
		_ENV = nodeType.awardTitle
		nodeType.awardTitle.nodeType = nodeType.awardScroll
		nodeType.awardTitle.posY = 0
		nodeType.awardTitle.awardItemPoints, _ENV, nodeType.awardTitle.awards = nodeType.awardScroll, nodeType.awardScroll, reward
		table.insert(self.scrollItems, nodeType.awardTitle)
		self.scrollH = self.scrollH + SCROLL_ITEM_HEIGHT
	end
end
function remainsWarRewardSeasonView:updateScrollDataStage_imp(danID, danInfo)
	_ENV = nil
	;(nil).nodeType = nodeType.awardTitleStage
	;(nil).posY = 0
	;(nil).min = danInfo.min or 0
	;(nil).max = danInfo.max or 0
	table.insert(self.scrollItems, nil)
	self.scrollH = self.scrollH + TITLE_HEIGHT
	do
		if not danInfo.reward then
			local _ENV, reward = danInfo.reward, danInfo.reward
		end
		_ENV = danInfo.max or 0
		;(danInfo.max or 0).nodeType = nodeType.awardScroll
		;(danInfo.max or 0).posY = 0
		;(danInfo.max or 0).awardItemPoints, _ENV, (danInfo.max or 0).awards = nodeType.awardScroll, nodeType.awardScroll, reward
		table.insert(self.scrollItems, danInfo.max or 0)
		self.scrollH = self.scrollH + SCROLL_ITEM_HEIGHT
	end
end
function remainsWarRewardSeasonView:updateScrollData()
	for k, v in ipairs(self.rewardStrenght) do
		self:updateScrollDataStrenght_imp(k, v)
	end
	for k, v in ipairs(self.rewardStage) do
		self:updateScrollDataStage_imp(k, v)
	end
end
function remainsWarRewardSeasonView:updateScrollList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	if self.offsetY and math.abs(self.offsetY - offsetY) < 100 then
		return
	end
	self.offsetY = offsetY
	local scrollH = self.scroll:getContentSize().height
	local beginY = math.max(0, offsetY - 150)
	local endY = offsetY + scrollH + 150
	for _, v in ipairs(self.scrollItems) do
		if v.point then
			if beginY > v.posY or endY < v.posY then
				self:recycleSingle(v)
			end
		elseif beginY <= v.posY and endY >= v.posY then
			local nType = v.nodeType
			local single = self:getSingle(nType)
			if nType == nodeType.awardTitle then
				single:setPositionY(v.posY)
				self:setTitle(single, 7)
			elseif nType == nodeType.awardTitleStage then
				single:setPositionY(v.posY)
				self:setTitleStage(single, v.min, v.max)
			elseif nType == nodeType.awardScroll then
				single:setPositionY(v.posY)
				single:setVisible(true)
				self:setAwards(single, v)
			end
			v.point = single
		end
	end
end
function remainsWarRewardSeasonView:getSingle(nType)
	local single
	if not self.listNode[nType] then
		local _ENV, listNode = self.listNode[nType], self.listNode[nType]
	end
	if 0 < #listNode then
		single = table.remove(listNode)
	else
		if nType == nodeType.awardTitle or nType == nodeType.awardTitleStage then
			single = self.nodeTitle:clone()
		elseif nType == nodeType.awardScroll then
			single = self.single:clone()
		elseif nType == nodeType.awardItem then
			single = include("commonItemAward").new()
			single:setOwnView(self:getParent():getParent():getParent():getParent())
			local size = cc.size(55, 22)
			single:setTextWidthHeight(size)
		end
		single:addTo(self.nodeReward)
	end
	single:setVisible(true)
	return single
end
function remainsWarRewardSeasonView:recycleSingle(single)
	local nType = single.nodeType
	local point = single.point
	if point then
		if nType == nodeType.awardTitle or nType == nodeType.awardTitleStage then
			point:setVisible(false)
			table.insert(self.listNode[nType], point)
			single.point = nil
		elseif nType == nodeType.awardScroll then
			point:setVisible(false)
			table.insert(self.listNode[nType], point)
			single.point = nil
			local awardItemPoints = single.awardItemPoints
			for _, v in ipairs(awardItemPoints) do
				v:setVisible(false)
				table.insert(self.listNode[nodeType.awardItem], v)
			end
			single.awardItemPoints, nodeType = ipairs(awardItemPoints)
		end
	end
end
function remainsWarRewardSeasonView:initScrollList()
	self.scrollH = 0
	self.offsetY = nil
	self:updateScrollData()
	self:updateScrollPos()
	self.scroll:jumpToTop()
	self:updateScrollList()
end
function remainsWarRewardSeasonView:setTitleStage(single, min, max)
	local txtScoreTitle = SoraDGetChildByName(single, "Text_score_title")
	if min == max then
		_ENV = nil
		;(nil).num = min
		txtScoreTitle:setString(i18n("common_text_617", nil))
	else
		_ENV = i18n("common_text_617", nil)
		i18n("common_text_617", nil).min = min
		i18n("common_text_617", nil).max = max
		txtScoreTitle:setString(i18n("common_text_1770", i18n("common_text_617", nil)))
	end
end
function remainsWarRewardSeasonView:setTitle(single, danID)
	local txtScoreTitle = SoraDGetChildByName(single, "Text_score_title")
	local strTitle = remainsWarRead.getDanName(danID)
	txtScoreTitle:setString(strTitle)
end
function remainsWarRewardSeasonView:setAwards(single, scoreData)
	local awardItemPoints = scoreData.awardItemPoints
	for k, v in ipairs(scoreData.awards) do
		local award = self:getSingle(nodeType.awardItem)
		award:initData(v.id, v.count)
		local posX = SoraDFPosX(185 - (k - 1) * 120, 0, 600)
		award:setPosition(cc.p(posX, scoreData.posY + 60))
		awardItemPoints[#awardItemPoints + 1] = award
	end
end
function remainsWarRewardSeasonView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollList()
	end
end
return remainsWarRewardSeasonView
