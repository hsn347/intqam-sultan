local heroJourneyCtrl = SoraDGetCtrl("heroJourneyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_reward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HeroJourney/Com_reward", Com_reward)
_ENV = fgui.register_extension
fgui.register_extension[1] = 1
fgui.register_extension[2] = 4
fgui.register_extension[3] = 5
fgui.register_extension[4] = 6
local _ENV, fgui.register_extension[5], boxIndex = "ui://HeroJourney/Com_reward", 8, fgui.register_extension
;("ui://HeroJourney/Com_reward")[1] = 18
;("ui://HeroJourney/Com_reward")[2] = 15
;("ui://HeroJourney/Com_reward")[3] = 2
;("ui://HeroJourney/Com_reward")[4] = -4
local _ENV, ("ui://HeroJourney/Com_reward")[5], boxAniOffsetY = Com_reward, -5, "ui://HeroJourney/Com_reward"
Com_reward[1] = 0
Com_reward[2] = 0
Com_reward[3] = -13
Com_reward[4] = 0
local Com_reward[5], boxAniOffsetX = -4, Com_reward
function Com_reward:onInit()
	for i = 1, 5 do
		self.fields["Ani_box" .. i]:setAllFrameName("dh_lshs_" .. boxIndex[i] .. "_%02d.png", 1)
		self.fields["Ani_box" .. i]:setPositionY(self.fields["Ani_box" .. i]:getPositionY() + boxAniOffsetY[i])
		self.fields["Ani_box" .. i]:setPositionX(self.fields["Ani_box" .. i]:getPositionX() + boxAniOffsetX[i])
	end
	self.fields.touch:addClickListener(handler(self, self.onClickReward))
end
function Com_reward:initData(index, data)
	self.index = index
	self.score = data.integral
	self.reward = data.reward
	self.fields.Text_score:setString(self.score)
	if heroJourneyCtrl:getScore() < self.score then
		self.fields.icon:setURL("icon_lshs_common_0" .. boxIndex[index] .. "_closed.png")
		self.controllers.c1:setSelectedIndex(0)
	elseif not heroJourneyCtrl:isInStageReward(self.index) and heroJourneyCtrl:getScore() >= self.score then
		self.controllers.ani:setSelectedIndex(index)
		self.fields.icon:setURL("icon_lshs_common_0" .. boxIndex[index] .. "_open.png")
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.ani:setSelectedIndex(0)
		self.fields.icon:setURL("icon_lshs_common_0" .. boxIndex[index] .. "_FullyOpen.png")
		self.controllers.c1:setSelectedIndex(2)
	end
end
function Com_reward:onClickReward()
	SoraDPlaySound()
	_ENV = nil
	;(nil).index = self.index
	;(nil).score = self.score
	;(nil).reward = self.reward
	uiManager:show("HeroJourneyReward", nil):setOwnerKey(self)
end
function Com_reward:onShow()
end
return Com_reward
