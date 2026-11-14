local smeltCtrl = SoraDGetCtrl("smeltCtrl")
local smeltRead = include("smeltRead")
local smeltReward = class("smeltReward", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("smeltReward")
end)
function smeltReward:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("Smelt_text_20"))
	self.textTips = SoraDGetChildByName(self, "Text_tips1")
	self.textTips = SoraDChangeTextToHtml(self.textTips)
	self.textTips2 = SoraDGetChildByName(self, "Text_tips2")
	self.textTips2 = SoraDChangeTextToHtml(self.textTips2)
	self.textTips3 = SoraDGetChildByName(self, "Text_tips3")
	self.textTips4 = SoraDGetChildByName(self, "Text_tips4")
	self.textTips3:setString(i18n("Smelt_text_22"))
	self.textTips4:setString(i18n("Smelt_text_21"))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.nodeAward2 = SoraDGetChildByName(self, "Node_Award2")
	self.tmpItem = SoraDGetChildByName(self, "Node_Item")
end
function smeltReward:onMessageListener()
end
function smeltReward:showRewards(awardNode, rewards)
	for i, v in ipairs(rewards) do
		local newItem = self.tmpItem:clone()
		newItem:setScale(0.8)
		local item = include("commonItemAward").new(SoraDGetChildByName(newItem, "Item"))
		item:setBaseScale(1)
		item:setOwnView(self)
		item:initData(v.id, v.count)
		newItem:setPositionY(0)
		newItem:addTo(awardNode)
	end
	SoraDToCenter(awardNode, 100, SoraDFIsRA())
end
function smeltReward:initData(rewards)
	local nowValue = smeltCtrl:getValue()
	local costValue = rewards.cost
	self.textTips3:setVisible(nowValue < costValue)
	self.textTips4:setVisible(nowValue >= costValue)
	smeltCtrl = nil
	smeltCtrl, smeltCtrl, (nil).num = nil, nil, costValue
	;(nil).num, (nil).color = nil, "#00BE1E"
	self.textTips:setString(i18n_html("Smelt_text_13", nil, nil))
	smeltCtrl = i18n_html("Smelt_text_13", nil, nil)
	smeltCtrl, smeltCtrl, i18n_html("Smelt_text_13", nil, nil).num = i18n_html("Smelt_text_13", nil, nil)
	i18n_html("Smelt_text_13", nil, nil).num, i18n_html("Smelt_text_13", nil, nil).color = i18n_html("Smelt_text_13", nil, nil)
	self.textTips2:setString(i18n_html("Smelt_text_12", i18n_html("Smelt_text_13", nil, nil)))
	_UPVALUE2_ = i18n_html("Smelt_text_12", i18n_html("Smelt_text_13", nil, nil))
	i18n_html("Smelt_text_12", i18n_html("Smelt_text_13", nil, nil))[1] = "id"
	i18n_html("Smelt_text_12", i18n_html("Smelt_text_13", nil, nil))[2] = "count"
	local rewards1 = serviceFunctions.tableFormat(rewards.reward1, i18n_html("Smelt_text_12", i18n_html("Smelt_text_13", nil, nil)))
	_UPVALUE2_ = "id"
	;("id")[1] = "id"
	;("id")[2] = "count"
	local rewards2 = serviceFunctions.tableFormat(rewards.reward2, "id")
	self:showRewards(self.nodeAward, rewards1)
	self:showRewards(self.nodeAward2, rewards2)
end
function smeltReward:onBtnGo(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
return smeltReward
