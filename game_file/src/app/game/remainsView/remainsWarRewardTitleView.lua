local remainsWarRewardRoundView = include("remainsWarRewardRoundView")
local remainsWarRead = include("remainsWarRead")
local remainsWarRewardTitleView = class("remainsWarRewardTitleView", remainsWarRewardRoundView)
_ENV = "remainsWarRewardTitleView"
;("remainsWarRewardTitleView").awardTitle = 1
;("remainsWarRewardTitleView").awardScroll = 2
local ("remainsWarRewardTitleView").awardItem, nodeType = 3, "remainsWarRewardTitleView"
local TITLE_HEIGHT = 50
local SCROLL_ITEM_HEIGHT = 80
function remainsWarRewardTitleView:ctor()
	remainsWarRewardTitleView.super.ctor(self)
	self.mvp:setVisible(false)
end
function remainsWarRewardTitleView:init()
	self.danList = remainsWarRead.getRuinsTitleReward()
	self:initScrollList()
end
function remainsWarRewardTitleView:updateScrollData_imp(title, titleInfo)
	_ENV = nil
	;(nil).nodeType = nodeType.awardTitle
	;(nil).posY = 0
	;(nil).title = title
	table.insert(self.scrollItems, nil)
	self.scrollH = self.scrollH + TITLE_HEIGHT
	do
		local _ENV, scoreList = self.scrollH + TITLE_HEIGHT, titleInfo or self.scrollH + TITLE_HEIGHT
		for k, v in ipairs(scoreList) do
			_ENV = nil
			;(nil).nodeType = nodeType.awardScroll
			;(nil).posY = 0
			;(nil).awards = v.reward
			;(nil).awardItemPoints, _ENV, (nil).rank = v.rank, v.rank, v.rank
			table.insert(self.scrollItems, nil)
			self.scrollH = self.scrollH + SCROLL_ITEM_HEIGHT
		end
	end
end
function remainsWarRewardTitleView:updateScrollData()
	for k = 1, #self.danList do
		local v = self.danList[k]
		self:updateScrollData_imp(k, v)
	end
end
function remainsWarRewardTitleView:setTitle(single, data)
	local titleType = data.title
	local txtScoreTitle = SoraDGetChildByName(single, "Text_score_title")
	local strTitle = remainsWarRead.getRuinsTitleName(titleType)
	txtScoreTitle:setString(strTitle)
	local spScore = SoraDGetChildByName(single, "Sprite_score")
	local imgScore = remainsWarRead.getRuinsTitleIcon(titleType)
	spScore:setSpriteFrame(imgScore)
end
function remainsWarRewardTitleView:setAwards(single, data)
	local txtDes = SoraDGetChildByName(single, "Text_des")
	local rankList = data.rank
	if rankList[1] == rankList[2] then
		_ENV = nil
		;(nil).num = rankList[1]
		txtDes:setString(i18n("common_text_617", nil))
	else
		_ENV = i18n("common_text_617", nil)
		i18n("common_text_617", nil).min = rankList[1]
		i18n("common_text_617", nil).max = rankList[2]
		txtDes:setString(i18n("common_text_1770", i18n("common_text_617", nil)))
	end
	local awardItemPoints = data.awardItemPoints
	for k, v in ipairs(data.awards) do
		local award = self:getSingle(nodeType.awardItem)
		award:initData(v.id, v.count)
		local posX = SoraDFPosX(130 - (k - 1) * 70, 0, 600)
		award:setPosition(cc.p(posX, data.posY + 40))
		awardItemPoints[#awardItemPoints + 1] = award
	end
end
return remainsWarRewardTitleView
