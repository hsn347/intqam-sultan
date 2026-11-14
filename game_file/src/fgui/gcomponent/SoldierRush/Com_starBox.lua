local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_starBox = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_starBox", Com_starBox)
function Com_starBox:onInit()
	self:addClickListener(handler(self, self.onBoxClick))
	self.fields.star:fixPos()
	self.fields.Text_star:fixPos()
end
function Com_starBox:onShow()
end
function Com_starBox:initData(chapter, index, curStars)
	self.chapter = chapter
	self.index = index
	local starRequire, starReward = soldierRushRead.getChapterStarCfg(chapter, index)
	self.stars = starRequire
	self.rewards = starReward
	self.fields.Text_star:setString(starRequire)
	local status = 0
	local boxStatus = gBtnTargetStatusDef.GO
	local isClaimed = soldierRushCtrl:isReward(chapter, index)
	if isClaimed then
		status = 2
		boxStatus = gBtnTargetStatusDef.GOT
	end
	if not isClaimed and curStars >= starRequire then
		status = 1
		boxStatus = gBtnTargetStatusDef.GET
	end
	self.status = boxStatus
	self.controllers.c1:setSelectedIndex(status)
	self.fields.box:initStyle(index + 5)
	self.fields.box:setStatus(boxStatus)
end
function Com_starBox:cliamReward()
	soldierRushCtrl:sendReward(self.chapter, self.index)
end
function Com_starBox:onBoxClick()
	SoraDPlaySound()
	local okStr = i18n("common_text_2139")
	if self.status == gBtnTargetStatusDef.GOT then
		okStr = i18n("common_text_1892")
	elseif self.status == gBtnTargetStatusDef.GET then
		okStr = i18n("common_text_1146")
	end
	_ENV = nil
	_ENV = nil
	;(nil).num = self.stars
	;(nil).title = i18n("soldier_rush_text_07", nil)
	;(nil).awardList = self.rewards
	;(nil).okStr = okStr
	;(nil).btnStatus = self.status
	;(nil).handle = handler(self, self.cliamReward)
	uiManager:show("Panel_gainView", nil)
end
return Com_starBox
