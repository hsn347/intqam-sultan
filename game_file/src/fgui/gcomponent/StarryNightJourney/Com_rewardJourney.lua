local starryNightJourneyCtrl = SoraDGetCtrl("starryNightJourneyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rewardJourney = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarryNightJourney/Com_rewardJourney", Com_rewardJourney)
function Com_rewardJourney:onInit()
	self:addClickListener(handler(self, self.onClickReward))
end
function Com_rewardJourney:initData(index, data)
	self.score = data.score
	self.index = index
	self.fields.Text_score:setString(self.score)
	self.controllers.box:setSelectedIndex(self.index - 1)
	if starryNightJourneyCtrl:getCurScore() < self.score then
		self.controllers.c1:setSelectedIndex(0)
	elseif not starryNightJourneyCtrl:hadgotGift(index) and starryNightJourneyCtrl:getCurScore() >= self.score then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(2)
		self.fields.resIcon:setColor(cc.c3b(153, 153, 153))
	end
end
function Com_rewardJourney:onClickReward()
	SoraDPlaySound()
	self.index = self.index or 1
	self.score = self.score or 0
	_ENV = nil
	;(nil).index = self.index
	;(nil).score = self.score
	uiManager:show("StarryNightReward", nil):setOwnerKey(self)
end
function Com_rewardJourney:onShow()
end
return Com_rewardJourney
