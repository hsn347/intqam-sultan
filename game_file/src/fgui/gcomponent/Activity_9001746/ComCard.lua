local publicRead = include("publicRead")
local activity_9001746_Ctrl = SoraDGetCtrl("activity_9001746_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local ComCard = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001746/ComCard", ComCard)
local BOOM_FRAME_NAME = "activity_9001680_boom_%02d.png"
local getTypeDebugText = function(data)
	local cardType = activity_9001746_Ctrl:getCardTypeEnum()
	local typeIndex = data.type
	if typeIndex == cardType.REWARD then
		return "奖励"
	end
	if typeIndex == cardType.BOMB then
		return "炮弹"
	end
	if typeIndex == cardType.BOX then
		local boxSpan = data.boxSpan or 1
		return string.format("宝箱%dx%d", boxSpan, boxSpan)
	end
	if typeIndex == cardType.PORTAL then
		return "传送门"
	end
	if typeIndex == cardType.NULL then
		return "空白"
	end
	return ""
end
function ComCard:onInit()
	self:addClickListener(handler(self, self.onClickSelf))
	self.data = nil
	self.clickCallback = nil
	self.fields.boom:setAllFrameName(BOOM_FRAME_NAME, 1)
	self.fields.boom:setVisible(false)
end
function ComCard:onShow()
end
function ComCard:resetCoverState(isCovered)
	self:stopAllActions()
	self.fields.n36:stopAllActions()
	self.transitions.t0:stop()
	self.fields.boom:setVisible(false)
	self.fields.n36:setAlpha(1)
	self.fields.n36:setScale(1, 1)
	self.fields.n36:setVisible(isCovered)
end
function ComCard:playRevealEffect()
	self:resetCoverState(true)
	self.transitions.t0:play(1, 0, 0, -1, function()
		self.fields.n36:setVisible(false)
	end)
end
function ComCard:playBoomEffect()
	self.fields.boom:setAllFrameName(BOOM_FRAME_NAME, 1)
	self.fields.boom:setVisible(true)
	self.fields.boom:setAlpha(1)
	self.fields.boom:setPlaySettings(0, -1, 1, -1, function()
		self.fields.boom:setVisible(false)
	end)
end
function ComCard:initData(data, clickCallback)
	local prevData = self.data
	self.data = data
	self.clickCallback = clickCallback
	local reward = self.data.reward
	local showReward = self.data.showReward == true and reward and reward.id > 0
	local showDebug = G_IS_Editor == true and userSDKManager.isBeta()
	local isCovered = self.data.isCovered ~= false
	local prevCovered = prevData == nil or prevData.isCovered ~= false
	local playRevealEffect = prevData ~= nil and prevData.key == self.data.key and prevCovered and not isCovered
	self:setVisible(true)
	self:setTouchEnabled(self.data.canClick ~= false)
	self.fields.icon:setVisible(showReward)
	self.fields.txtNum:setVisible(showReward)
	self.fields.txtDebug:setVisible(showDebug)
	self.fields.txtDebug:setString(showDebug and getTypeDebugText(self.data) or "")
	self.fields.icon:setURL(showReward and publicRead.getIcon(reward.id) or "")
	self.fields.txtNum:setString(showReward and string.formatnumberthousands(reward.count) or "")
	if playRevealEffect then
		self:playRevealEffect()
	else
		self:resetCoverState(isCovered)
	end
end
function ComCard:playHitEffect()
	self:stopAllActions()
	self.fields.n36:stopAllActions()
	self:setScale(1, 1)
	self.fields.n36:setAlpha(1)
	_UPVALUE1_ = 1
	;(1)[1] = ffa.scaleTo(0.06, 0.94)
	;(1)[2] = ffa.scaleTo(0.08, 1)
	;(1)[3] = ffa.scaleTo(0.08, 1)
	;(1)[4] = ffa.scaleTo(0.08, 1)
	self:runAction(ffa.seq(1))
	_UPVALUE1_ = ffa.seq(1)
	ffa.seq(1)[1] = ffa.fadeTo(0.04, 0.65)
	ffa.seq(1)[2] = ffa.fadeTo(0.08, 1)
	ffa.seq(1)[3] = ffa.fadeTo(0.08, 1)
	ffa.seq(1)[4] = ffa.fadeTo(0.08, 1)
	self.fields.n36:runAction(ffa.seq(ffa.seq(1)))
end
function ComCard:onClickSelf()
	if self.data.canClick ~= false and self.clickCallback then
		self.clickCallback(self.data)
	end
end
return ComCard
