local starTreasureHuntCtrl = SoraDGetCtrl("starTreasureHuntCtrl")
local starTreasureHuntRead = include("starTreasureHuntRead")
local starsTreasureRewardView = class("starsTreasureRewardView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("starsTreasureRewardView")
end)
function starsTreasureRewardView:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("starMaze_text_02"))
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips:setString(i18n("starMaze_text_03"))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self:initData()
end
function starsTreasureRewardView:initData()
	for i, v in ipairs(starTreasureHuntRead.getAwardByValue()) do
		local item = include("commonItemAward").new()
		item:addTo(self.nodeAward)
		item:setBaseScale(1)
		item:setOwnView(self)
		item:initData(v.itemid, v.count)
		local isGet = starTreasureHuntCtrl:itemIsLock(v.itemid)
		item:setGot(isGet)
	end
	SoraDautoSortPos(self.nodeAward, 4, 1, cc.size(110, 110), SoraDFIsRA())
end
return starsTreasureRewardView
