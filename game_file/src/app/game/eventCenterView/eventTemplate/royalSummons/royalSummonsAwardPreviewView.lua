local royalSummonsUtil = include("royalSummonsUtil")
local royalSummonsCtrl = SoraDGetCtrl("royalSummonsCtrl")
local royalSummonsRead = include("royalSummonsRead")
local ROYAL_SUMMONS_AWARD_TYPE = royalSummonsUtil.ROYAL_SUMMONS_AWARD_TYPE
local MAX_ROW_NUM = 4
local royalSummonsAwardPreviewView = class("royalSummonsAwardPreviewView", function(target)
	if target == nil then
		if royalSummonsCtrl:getClassType() == 1 then
			return SoraDCreateTouchPanel("royalSummonsAwardPreviewView")
		else
			return SoraDCreateTouchPanel("dashToSkyAwardPreView")
		end
	end
	return target
end)
function royalSummonsAwardPreviewView:ctor()
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.txtTips = SoraDGetChildByName(self, "Text_tips")
	self.txtTips:setString(i18n(royalSummonsCtrl:getClassType() == 1 and "summoned_text_24" or "summoned_text_60"))
	SoraDSetTextWidthHeight(self.txtTips, cc.size(500, 60))
	self.txtTips:setVisible(false)
	self.nodeTitleNormal = SoraDGetChildByName(self, "Node_title_normal")
	self.nodeTitleGold = SoraDGetChildByName(self, "Node_title_gold")
	self.single = SoraDGetChildByName(self, "Node_single")
	self.single:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_award")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	if self.textTitle then
		self.textTitle:setString(i18n("summoned_text_07"))
	end
	self:initData()
end
function royalSummonsAwardPreviewView:initData()
	if royalSummonsCtrl:getClassType() == 2 then
		self:setBackGround(0)
		local cssFileName = "dashToSkyAwardPreView"
		local cssFilePath = getCCSPath(cssFileName)
		local action = cc.CSLoader:createTimeline(cssFilePath)
		action:gotoFrameAndPlay(0, 37, false)
		if action and tolua.cast(action, "cc.Action") then
			action:setFrameEventCallFunc(function(frameEventName)
				local frameEvent = frameEventName:getEvent()
				if frameEvent and frameEvent == "ActionEnd" then
					action:gotoFrameAndPlay(38, 118, true)
				end
			end)
		end
		self:runAction(action)
	end
	self.itemList, royalSummonsCtrl = "dashToSkyAwardPreView", cssFileName
	self.itemList[ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD], royalSummonsCtrl = cc.CSLoader:createTimeline(cssFilePath), cc.CSLoader:createTimeline(cssFilePath)
	self.itemList[ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_NORMAL], royalSummonsCtrl = cc.CSLoader:createTimeline(cssFilePath), cc.CSLoader:createTimeline(cssFilePath)
	local insertAward = function(itemData, awardType)
		local awardList = self.itemList[awardType]
		for _, v in ipairs(itemData) do
			awardList[#awardList + 1] = v
		end
	end
	if not royalSummonsRead:getAwardShowList(royalSummonsCtrl:getClassType()) then
		local royalSummonsCtrl, awardShowList = royalSummonsRead:getAwardShowList(royalSummonsCtrl:getClassType()), royalSummonsRead:getAwardShowList(royalSummonsCtrl:getClassType())
	end
	dump(awardShowList, "awardShowList", 10)
	for _, v in ipairs(awardShowList) do
		local awardType = v.type or ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_NORMAL
		insertAward(v.award, awardType)
	end
	dump(self.itemList, "self.itemList", 10)
	self:initScrollList()
end
function royalSummonsAwardPreviewView:initScrollList()
	self.scrollH = 0
	self.offsetY = nil
	self:updateScrollData()
	self:updateScrollPos()
	if royalSummonsCtrl:getClassType() == 2 then
		self.scroll:getInnerContainer():setPositionY(-self.scroll:getInnerContainerSize().height)
		_ENV = self.scroll
		self.scroll[1] = cca.delay(0.23333333333333334)
		self.scroll[2] = cca.callFunc(function(...)
			self.scroll:scrollToTop(0.45, true)
		end)
		self.scroll[3] = cca.callFunc(function(...)
			self.scroll:scrollToTop(0.45, true)
		end)
		self:runAction(cca.seq(self.scroll))
	end
end
local TITLE_HEIGHT = 50
local SCROLL_ITEM_HEIGHT = 140
function royalSummonsAwardPreviewView:updateScrollPos()
	local sSize = self.scroll:getContentSize()
	local listHeight = self.scrollH + 10
	local sH = math.max(sSize.height, listHeight)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	self.nodeReward:setPositionY(sH)
end
function royalSummonsAwardPreviewView:updateScrollData()
	for k, v in ipairs(self.itemList) do
		self:updateScrollData_imp(k, v)
	end
end
function royalSummonsAwardPreviewView:updateScrollData_imp(taskType, itemInfo)
	self:getSingle_Title(taskType)
	if taskType == ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD then
		local height = self.txtTips:getContentSize().height
		self.txtTips:setVisible(true)
		self.txtTips:setPositionY(-self.scrollH)
		self.scrollH = self.scrollH + height
	end
	self:getSingle_AwardPanel(taskType, itemInfo)
end
function royalSummonsAwardPreviewView:getSingle_Title(taskType)
	local single
	if taskType == ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD then
		single = self.nodeTitleGold
	else
		single = self.nodeTitleNormal
	end
	local strTitle
	if taskType == ROYAL_SUMMONS_AWARD_TYPE.ROYAL_SUMMONS_AWARD_TYPE_GOLD then
		strTitle = royalSummonsCtrl:getClassType() == 1 and i18n("summoned_text_23") or i18n("summoned_text_59")
	else
		strTitle = royalSummonsCtrl:getClassType() == 1 and i18n("summoned_text_25") or i18n("summoned_text_61")
	end
	local txtScoreTitle = SoraDGetChildByName(single, "Text_score_title")
	txtScoreTitle:setString(strTitle)
	single:setPositionY(-self.scrollH)
	self.scrollH = self.scrollH + TITLE_HEIGHT
	return single
end
function royalSummonsAwardPreviewView:getSingle_AwardPanel(taskType, itemInfo)
	local single = self.single:clone()
	single:addTo(self.nodeReward)
	single:setVisible(true)
	single:setPositionY(-self.scrollH)
	for k, v in ipairs(itemInfo) do
		local award = self:getSingle_AwardItem()
		award:initItem(v)
		local x = (k - 1) % MAX_ROW_NUM
		local y = math.floor((k - 1) / MAX_ROW_NUM)
		local posX = SoraDFPosX(185 - x * 120, 0, 600)
		local posy = y * SCROLL_ITEM_HEIGHT
		award:setPosition(cc.p(posX, -(self.scrollH + 80 + posy)))
	end
	self.scrollH = self.scrollH + math.ceil(#itemInfo / MAX_ROW_NUM) * SCROLL_ITEM_HEIGHT
end
function royalSummonsAwardPreviewView:getSingle_AwardItem()
	local single = include("royalSummonsAwardItem").new()
	single:addTo(self.nodeReward)
	single:setCascadeOpacityEnabled(true)
	single:setVisible(true)
	single:setOwnView(self)
	local size = cc.size(55, 22)
	single:setTextWidthHeight(size)
	return single
end
return royalSummonsAwardPreviewView
