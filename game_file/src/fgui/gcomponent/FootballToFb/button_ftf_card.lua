local pitchAgainstHeadCtrl = SoraDGetCtrl("pitchAgainstHeadCtrl")
local baseComponent = require("fgui.base.baseComponent")
local button_ftf_card = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://FootballToFb/button_ftf_card", button_ftf_card)
function button_ftf_card:onInit()
	self.fields.Usm_1:setVisible(false)
end
function button_ftf_card:showReward(isAct)
	if self.data then
		local ret = pitchAgainstHeadCtrl:isAwardPitch(self.cType, self.index)
		self.controllers.c2:setSelectedIndex(1)
		self.fields.reward:initData(ret, self.data[3].id, self.data[3].count, self.isShowGot)
		if isAct then
			self.fields.reward:setAlpha(0)
			self.fields.reward:runAction(ffa.fadeIn(0.3))
		else
			self.fields.reward:stopAllActions()
			self.fields.reward:setAlpha(1)
		end
	else
		self.fields.bg:stopAllActions()
		self.fields.bg:setAlpha(1)
		self.controllers.c1:setSelectedIndex(self.cType - 1)
		self.controllers.c2:setSelectedIndex(0)
	end
end
function button_ftf_card:initData(cType, index, data, isFromMsg, flipData)
	self.cType = cType
	self.index = index
	self.data = data
	self.isFromMsg = isFromMsg
	self.flipData = flipData
	self.isShowGot = false
	if self.data then
		if isFromMsg and flipData.index and flipData.index == self.index and flipData.cType and flipData.cType == self.cType then
			self.isShowGot = true
			self.fields.Usm_1:play()
			self.fields.bg:runAction(ffa.fadeOut(0.4))
			_UPVALUE1_ = ffa.fadeOut(0.4)
			ffa.fadeOut(0.4)[1] = ffa.delay(0.4)
			ffa.fadeOut(0.4)[2] = ffa.callFunc(function()
				self:showReward(true)
			end)
			ffa.fadeOut(0.4)[3] = ffa.callFunc(function()
				self:showReward(true)
			end)
			self:runAction(ffa.seq(ffa.fadeOut(0.4)))
		else
			self:showReward()
		end
	else
		self.fields.bg:stopAllActions()
		self.fields.bg:setAlpha(1)
		self.controllers.c1:setSelectedIndex(self.cType - 1)
		self.controllers.c2:setSelectedIndex(0)
	end
end
return button_ftf_card
