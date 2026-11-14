local castleRewardCtrl = SoraDGetCtrl("castleRewardCtrl")
local mainUIDef = include("mainUIDef")
local castleRewardSingle = class("castleRewardSingle", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("castleRewardSingle")
end)
function castleRewardSingle:ctor(properties)
	self:setCascadeOpacityEnabled(true)
	self.nodeCommonItemAward = SoraDPopItemAward()
	self.nodeCommonItemAward:setGroupOn()
	self.nodeCommonItemAward:setCascadeOpacityEnabled(true)
	self.nodeCommonItemAward:setCascadeColorEnabled(true)
	self.nodeCommonItemAward:setPosition(0, 0)
	self.nodeCommonItemAward:setScale(0.8)
	self.nodeCommonItemAward:addTo(SoraDGetChildByName(self, "Node_item"), 1)
	self.nodeCommonItemAward:setBaseScale(1.0)
	self.icon_r = SoraDGetChildByName(self, "icon_czhl_g_29")
	self.icon_r:setGroupID(mainUIDef.uiGroupID.group_award_item + 24)
	self.icon_lock = SoraDGetChildByName(self, "icon_lock")
	self.icon_lock:setGroupID(mainUIDef.uiGroupID.group_award_item + 24)
	self.normalEf = SoraDGetChildByName(self, "Effect_normal")
	self.normalEf:setGroupID(mainUIDef.uiGroupID.group_award_item + 25)
	self.goldEf = SoraDGetChildByName(self, "Effect_gold")
	self.goldEf:setGroupID(mainUIDef.uiGroupID.group_award_item + 25)
	self.panelClick = SoraDGetChildByName(self, "Panel_click")
	self.panelClick:addTouchEventListener(handler(self, self.buttonGetRewardCallBack))
	self.isInited = false
end
function castleRewardSingle:initEffect()
	if self.isInited then
		return
	end
	self.isInited = true
	local startIdx = math.random(1, 100)
	local effect_show, effectAction = SoraDCreatAnimation(self.__cname, self, true)
	effectAction:gotoFrameAndPlay(startIdx, 100, false)
	_UPVALUE1_ = 100
	;(100)[1] = cca.delay((100 - startIdx) / 60)
	;(100)[2] = cca.callFunc(function()
		effectAction:gotoFrameAndPlay(0, 100, true)
	end)
	;(100)[3] = cca.callFunc(function()
		effectAction:gotoFrameAndPlay(0, 100, true)
	end)
	self:runAction(cca.seq(100))
end
function castleRewardSingle:initData(award, isGot, canGet, isGold, isBuy, castleLv)
	self.nodeCommonItemAward:initData(award.id, award.count)
	self.icon_r:setVisible(isGot)
	self.icon_lock:setVisible(not isBuy and isGold)
	if isGot or not canGet and not isGot then
		self.nodeCommonItemAward:setColor(cc.c3b(125, 125, 125))
	else
		self.nodeCommonItemAward:setColor(cc.c3b(255, 255, 255))
	end
	self.normalEf:setVisible(not isGold and canGet)
	self.goldEf:setVisible(isGold and canGet)
	if self.normalEf:isVisible() or self.goldEf:isVisible() then
		self:initEffect()
	end
	self.panelClick:setVisible(canGet)
	self.castleLv = castleLv
	self.isGold = isGold
end
function castleRewardSingle:setOwnScroll(parent)
	self.nodeCommonItemAward:setOwnScroll(parent)
	self.scroll = parent
end
function castleRewardSingle:buttonGetRewardCallBack(target, eventType)
	if eventType == ccui.TouchEventType.ended and SoraDIsNodeVisibleOnScroll(target, self.scroll, eventType) then
		SoraDPlaySound()
		if self.isGold then
			castleRewardCtrl:reqGetReward(2, self.castleLv)
		else
			castleRewardCtrl:reqGetReward(1, self.castleLv)
		end
	end
end
return castleRewardSingle
