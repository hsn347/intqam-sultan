local shiningStarLightRead = include("shiningStarLightRead")
local shiningStarLightCtrl = SoraDGetCtrl("shiningStarLightCtrl")
local shiningStarLightFinalAward = class("shiningStarLightFinalAward", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("shiningStarLightFinalAward")
end)
function shiningStarLightFinalAward:ctor(properties)
	self.status = false
	self.textScore = SoraDGetChildByName(self, "Text_score_title")
	self.textScore:setString(i18n("Glorious_text_04"))
	self.nodeReward = SoraDGetChildByName(self, "Node_reward")
	self.btnGo = SoraDGetChildByName(self, "Button_Go")
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClick))
	self:initData()
end
function shiningStarLightFinalAward:onMessageListener()
end
function shiningStarLightFinalAward:initData(target, data)
	local lv = shiningStarLightCtrl:getInitCastleLv()
	local reward = shiningStarLightRead.getFinalReward(lv)
	for i, v in ipairs(reward) do
		local single = include("commonItemAward").new()
		single:setScale(0.9)
		single:setBaseScale(1.0)
		single:setOwnView(self)
		single:setPositionY(0)
		single:addTo(self.nodeReward)
		single:initData(v.id, v.count)
	end
	SoraDToCenter(self.nodeReward, 100)
	if shiningStarLightCtrl:getBoxIsOpen() == 0 then
		self.btnGo:setBright(true)
		self.btnGo:setTouchEnabled(true)
		if shiningStarLightCtrl:getStarLampIndex() == 5 then
			self.btnGo:setTitleText(i18n("common_text_1146"))
			self.status = true
		else
			self.status = false
			self.btnGo:setTitleText(i18n("common_text_204"))
		end
	else
		self.btnGo:setTitleText(i18n("common_text_1892"))
		self.btnGo:setBright(false)
		self.btnGo:setTouchEnabled(false)
	end
end
function shiningStarLightFinalAward:btnGoClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if self.status then
			shiningStarLightCtrl:reqGloriousStarLampOpenBox()
		end
		self:removeFromParent()
	end
end
function shiningStarLightFinalAward:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return shiningStarLightFinalAward
