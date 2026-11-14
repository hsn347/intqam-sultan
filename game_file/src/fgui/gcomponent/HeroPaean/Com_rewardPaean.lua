local heroPaeanRead = include("heroPaeanRead")
local heroPaeanCtrl = SoraDGetCtrl("heroPaeanCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rewardPaean = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HeroPaean/Com_rewardPaean", Com_rewardPaean)
function Com_rewardPaean:onInit()
end
function Com_rewardPaean:onInit()
	self:addClickListener(handler(self, self.onClickReward))
end
function Com_rewardPaean:initData(index, data)
	self.score = data.score
	self.index = index
	self.rewards = data.rewards
	self.fields.Text_score:setString(self.score)
	self.controllers.box:setSelectedIndex(self.index - 1)
	self.state = 1
	if heroPaeanCtrl:getScore() < self.score then
		self.controllers.c1:setSelectedIndex(0)
	elseif not heroPaeanCtrl:isInStageReward(index) and heroPaeanCtrl:getScore() >= self.score then
		self.controllers.c1:setSelectedIndex(1)
		self.state = 2
	else
		self.controllers.c1:setSelectedIndex(2)
		self.fields.resIcon:setColor(cc.c3b(153, 153, 153))
		self.state = 3
	end
end
function Com_rewardPaean:onClickReward()
	SoraDPlaySound()
	_ENV = SoraDPlaySound
	SoraDPlaySound.index = self.index
	SoraDPlaySound.score = self.score
	SoraDPlaySound.rewards = self.rewards
	SoraDPlaySound.state = self.state
	local SoraDPlaySound.backHandle, param = function(stageID)
		heroPaeanCtrl:sendStageRewardMsg(stageID)
	end, SoraDPlaySound
	uiManager:show("HeroPaeanReward", param):setOwnerKey(self)
end
function Com_rewardPaean:onShow()
end
return Com_rewardPaean
