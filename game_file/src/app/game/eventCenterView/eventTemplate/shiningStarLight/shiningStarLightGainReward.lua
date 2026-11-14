local shiningStarLightGainReward = class("shiningStarLightGainReward", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("shiningStarLightGainReward")
end)
function shiningStarLightGainReward:ctor(properties)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.textInstruct = SoraDGetChildByName(self, "text_instruct")
	self.nodeReward = SoraDGetChildByName(self, "Node_Reward")
	self.nodeShiningStarLightSingle = SoraDGetExtendChildFromCCSByName(self, "CCS_shiningStarLightSingle")
	self.btnGo = SoraDGetChildByName(self, "Button_Go")
	self.btnGo:setTitleText(i18n("common_text_204"))
	self.btnGo:addTouchEventListener(handler(self, self.btnGoClick))
	self:setCloseCallBack(handler(self, self.onClose))
end
function shiningStarLightGainReward:onMessageListener()
end
function shiningStarLightGainReward:initData(data)
	self.nodeShiningStarLightSingle:initData(data.index, false)
	_ENV = nil
	;(nil).name = i18n("Glorious_text_1" .. data.index)
	self.textInstruct:setString(i18n("Glorious_text_07", nil))
	self.reward = data.reward
	for i, v in ipairs(self.reward) do
		local single = include("commonItemAward").new()
		single:setScale(0.8)
		single:setBaseScale(1.0)
		single:setOwnView(self)
		single:setPositionY(0)
		single:addTo(self.nodeReward)
		single:initData(v.id, v.count)
	end
	SoraDToCenter(self.nodeReward, 100)
end
function shiningStarLightGainReward:btnGoClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDMailGainItems(self.reward, true)
		self:removeFromParent()
	end
end
function shiningStarLightGainReward:onClose()
	SoraDMailGainItems(self.reward, true)
end
function shiningStarLightGainReward:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return shiningStarLightGainReward
