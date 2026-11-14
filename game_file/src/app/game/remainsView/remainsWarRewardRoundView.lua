local remainsWarltCtrl = include("remainsWarltCtrl")
local remainsWarRead = include("remainsWarRead")
local remainsWarRewardRoundView = class("remainsWarRewardRoundView", function(ccsFileName)
	local target = SoraDCreateBasePanel("remainsWarRewardRoundView")
	SoraDDeviceFitOffset(target)
	return target
end)
_ENV = "remainsWarRewardRoundView"
;("remainsWarRewardRoundView").awardTitle = 1
;("remainsWarRewardRoundView").awardScroll = 2
local ("remainsWarRewardRoundView").awardItem, nodeType = 3, "remainsWarRewardRoundView"
function remainsWarRewardRoundView:ctor()
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.nodeTitle = SoraDGetChildByName(self, "Node_title")
	self.nodeTitle:setVisible(false)
	self.single = SoraDGetChildByName(self, "Node_single")
	self.single:setVisible(false)
	local txtDes = SoraDGetChildByName(self.single, "Text_des")
	txtDes:setPositionX(SoraDFPosX(600, 640))
	self.scroll = SoraDGetChildByName(self, "ScrollView_award")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.listNode, _ENV, self.scrollItems, _ENV = self.scroll.addEventListener, self.scroll.addEventListener, self.scroll.addEventListener, self.scroll.addEventListener
	for _, v in pairs(nodeType) do
		self.listNode[v], _ENV = handler(self, self.scrollEventCallBack)
	end
	self.mvp = SoraDGetChildByName(self, "Text_mvp")
	self.mvp:setString(i18n("remains_text_135"))
end
function remainsWarRewardRoundView:init()
	self.danList = remainsWarltCtrl:getRewars()
	self:initScrollList()
end
local TITLE_HEIGHT = 50
local SCROLL_ITEM_HEIGHT = 80
function remainsWarRewardRoundView:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = self.scrollH + 10
	local sH = math.max(sSize.height, listHeight)
	local posY = sH
	for _, v in ipairs(self.scrollItems) do
		if v.nodeType == nodeType.awardTitle then
			posY = posY - TITLE_HEIGHT
		elseif v.nodeType == nodeType.awardScroll then
			posY = posY - SCROLL_ITEM_HEIGHT
		end
		v.posY = posY
	end
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeReward:setPositionY(0)
end
function remainsWarRewardRoundView:updateScrollData_imp(danID, danInfo)
	if 8 < danID then
		return
	end
	_ENV = nil
	;(nil).nodeType = nodeType.awardTitle
	;(nil).posY = 0
	;(nil).danID = danID
	table.insert(self.scrollItems, nil)
	self.scrollH = self.scrollH + TITLE_HEIGHT
	do
		local _ENV, scoreList = self.scrollH + TITLE_HEIGHT, danInfo or self.scrollH + TITLE_HEIGHT
		for k, v in ipairs(scoreList) do
			if 6 <= k then
				return
			end
			_ENV = nil
			;(nil).nodeType = nodeType.awardScroll
			;(nil).posY = 0
			;(nil).scoreID = k
			;(nil).awardItemPoints, _ENV, (nil).awards = nodeType.awardScroll, nodeType.awardScroll, v
			table.insert(self.scrollItems, nil)
			self.scrollH = self.scrollH + SCROLL_ITEM_HEIGHT
		end
	end
end
function remainsWarRewardRoundView:updateScrollData()
	_UPVALUE8_ = nil
	;(nil)[1] = 1
	;(nil)[2] = 2
	;(nil)[3] = 3
	;(nil)[4] = 4
	;(nil)[5] = 5
	;(nil)[6] = 6
	;(nil)[7] = 8
	local (nil)[8], sList = 7, nil
	for i = #sList, 1, -1 do
		local v = self.danList[sList[i]]
		self:updateScrollData_imp(sList[i], v)
	end
end
function remainsWarRewardRoundView:updateScrollList()
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
				self:setTitle(single, v)
			elseif nType == nodeType.awardScroll then
				single:setPositionY(v.posY)
				single:setVisible(true)
				self:setAwards(single, v)
			end
			v.point = single
		end
	end
end
function remainsWarRewardRoundView:getSingle(nType)
	local single
	if not self.listNode[nType] then
		local _ENV, listNode = self.listNode[nType], self.listNode[nType]
	end
	if 0 < #listNode then
		single = table.remove(listNode)
	else
		if nType == nodeType.awardTitle then
			single = self.nodeTitle:clone()
		elseif nType == nodeType.awardScroll then
			single = self.single:clone()
		elseif nType == nodeType.awardItem then
			single = include("commonItemAward").new()
			single:setOwnView(self:getParent():getParent():getParent():getParent())
			local size = cc.size(55, 22)
			single:setTextWidthHeight(size)
			single:setBaseScale(1.0)
			single:setScale(0.6)
		end
		single:addTo(self.nodeReward)
	end
	single:setVisible(true)
	return single
end
function remainsWarRewardRoundView:recycleSingle(single)
	local nType = single.nodeType
	local point = single.point
	if point then
		if nType == nodeType.awardTitle then
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
function remainsWarRewardRoundView:initScrollList()
	self.scrollH = 0
	self.offsetY = nil
	self:updateScrollData()
	self:updateScrollPos()
	self.scroll:jumpToTop()
	self:updateScrollList()
end
function remainsWarRewardRoundView:setTitle(single, data)
	local danID = data.danID
	local txtScoreTitle = SoraDGetChildByName(single, "Text_score_title")
	local strTitle = remainsWarRead.getDanName(danID)
	txtScoreTitle:setString(strTitle)
	local color = remainsWarRead.getDanColor(danID)
	txtScoreTitle:setColor(color)
	local spScore = SoraDGetChildByName(single, "Sprite_score")
	local imgScore = remainsWarRead.getDanIcon(danID)
	spScore:setSpriteFrame(imgScore)
end
function remainsWarRewardRoundView:setAwards(single, scoreData)
	local txtDes = SoraDGetChildByName(single, "Text_des")
	local scoreName = remainsWarRead.getScoreName(scoreData.scoreID)
	_ENV = nil
	;(nil).num = scoreName
	txtDes:setString(i18n("remains_text_128", nil))
	local awardItemPoints = scoreData.awardItemPoints
	for k, v in ipairs(scoreData.awards) do
		local award = self:getSingle(nodeType.awardItem)
		award:initData(v.id, v.count)
		local posX = SoraDFPosX(130 - (k - 1) * 70, 0, 600)
		award:setPosition(cc.p(posX, scoreData.posY + 40))
		awardItemPoints[#awardItemPoints + 1] = award
	end
end
function remainsWarRewardRoundView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:updateScrollList()
	end
end
return remainsWarRewardRoundView
