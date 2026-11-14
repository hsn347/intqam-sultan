local bubbleActivityCtrl = SoraDGetCtrl("bubbleActivityCtrl")
local bubbleRewardPopView = class("bubbleRewardPopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end)
_ENV, _ENV = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end, "bubbleRewardPopView"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end).TopImage = "frame_zyjq_zs_01.png"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end).des = "bubbleActivity_text_02"
_ENV, ("bubbleRewardPopView")[1], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end).spTitle = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end, "frame_zyjq_"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end).TopImage = "frame_gdezy_qjt.png"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end).des = "bubbleActivity_text_03"
_ENV, ("bubbleRewardPopView")[2], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end).spTitle = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end, "frame_gdezy_"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end).TopImage = "frame_zykl_zs_01.png"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end).des = "bubbleActivity_text_04"
;("bubbleRewardPopView")[3], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end).spTitle = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("bubbleRewardPopView")
end, "frame_kzkl_"
local activityInfo = "bubbleRewardPopView"
function bubbleRewardPopView:ctor(properties)
	self.activityID = gActivityTimeActivityID.BUBBLE_REWARD_ACTIVITY
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.spTopImage = SoraDGetChildByName(self, "frame_topImage")
	self.spTitle = SoraDGetChildByName(self, "frame_Title")
	self.textTime = SoraDGetChildByName(self, "Text_Time")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.nodeReward = SoraDGetChildByName(self, "Node_Reward")
	self.pEffectList = SoraDGetChildsArrayByName(self, "Node_PEffect", 3, 1)
	self.effectList = SoraDGetChildsArrayByName(self, "Effect_Node_", 3, 1)
	self.starList = SoraDGetChildsArrayByName(self, "icon_zykl_star_", 3, 1)
	self.textDes = SoraDGetChildByName(self, "Text_Des")
	self.btnGet = SoraDGetChildByName(self, "Button_get")
	self.nodeGot = SoraDGetChildByName(self, "Node_Got")
	SoraDGetChildByName(self, "Text_Got"):setString(i18n("common_text_1892"))
	self.btnGet:setTitleText(i18n("common_text_1146"))
	self.btnGet:addTouchEventListener(handler(self, self.btnGetClick))
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips:setString(i18n("bubbleActivity_text_05"))
	self:initEffect()
	self:initActivityTime()
	self:initData()
end
function bubbleRewardPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_BUBBLE_ACTIVITY_REFRESH", handler(self, self.updateView))
end
function bubbleRewardPopView:initData(target, data)
	self.skinIndex = bubbleActivityCtrl:getSkinIndex() or 2
	self.spTopImage:setSpriteFrame(activityInfo[self.skinIndex].TopImage)
	self.textDes:setString(i18n(activityInfo[self.skinIndex].des))
	self.spTitle:setSpriteFrame(string.format("%s%s.png", activityInfo[self.skinIndex].spTitle, SoraDFIsRA() and "ar" or "en"))
	self:updateView()
	if not bubbleActivityCtrl:getRewardList() then
		bubbleActivityCtrl = bubbleActivityCtrl:getRewardList()
	end
	for i, v in ipairs((bubbleActivityCtrl:getRewardList())) do
		local itemAward = include("commonItemAward").new()
		itemAward:setRealScale(0.9)
		itemAward:setOwnView(self)
		itemAward:setPosition(0, 0)
		itemAward:addTo(self.nodeReward)
		itemAward:initData(v.id, v.count)
	end
	SoraDToCenter(self.nodeReward, 100, SoraDFIsRA())
	self:updateEffect()
end
function bubbleRewardPopView:updateView()
	local isGot = bubbleActivityCtrl:isCanReceive()
	self.btnGet:setVisible(isGot)
	self.nodeGot:setVisible(not isGot)
	self.textTips:setVisible(isGot)
	SoraDGetChildByName(self, "Particle_1_0"):setVisible(isGot)
end
function bubbleRewardPopView:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textTime:setTimeLast(function(ticket)
		return i18n("common_text_2669") .. ticket
	end)
	if self.eventTime then
		self.textTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
end
function bubbleRewardPopView:initEffect()
	for i, v in ipairs(self.effectList) do
		local effectNode = SoraDCreatAnimationEx("bubbleEffect_" .. i, nil, true)
		self.effectList[i]:addChild(effectNode)
		SoraDMixtureGLONEByParent(self.pEffectList[i])
		SoraDMixtureGLONEByParent(self.effectList[i])
		if i == 1 then
			SoraDGetChildByName(effectNode, "Sprite_4"):setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
			SoraDGetChildByName(effectNode, "Sprite_4_0"):setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		end
		self.starList[i]:runAction(cca.repeatForever(cca.seq(cca.rotateBy(7.35, 360))))
	end
	local loop = true
	local cssFileName = "bubbleRewardPopView"
	local cssFilePath = getCCSPath(cssFileName)
	self.action = cc.CSLoader:createTimeline(cssFilePath)
	self.action:gotoFrameAndPlay(0, loop)
	self:runAction(self.action)
end
function bubbleRewardPopView:updateEffect()
	for i = 1, 3 do
		self.pEffectList[i]:setVisible(i == self.skinIndex)
		self.effectList[i]:setVisible(i == self.skinIndex)
	end
end
function bubbleRewardPopView:btnGetClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if bubbleActivityCtrl:isCanReceive() then
			bubbleActivityCtrl:reqBubbleRewardReceive()
		else
			SoraDShowMsgTip(i18n("privilege_text_127"))
		end
	end
end
return bubbleRewardPopView
