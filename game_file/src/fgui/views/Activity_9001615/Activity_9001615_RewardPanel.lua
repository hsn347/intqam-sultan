local activity_9001615_Ctrl = SoraDGetCtrl("activity_9001615_Ctrl")
local activity_9001615_Read = include("activity_9001615_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001615_RewardPanel = class("Activity_9001615_RewardPanel", baseFguiPanel)
function Activity_9001615_RewardPanel:ctor(...)
	Activity_9001615_RewardPanel.super.ctor(self, ...)
	print("Activity_9001615_RewardPanel:ctor", self.viewName)
end
function Activity_9001615_RewardPanel:onInit()
	self:fixChildrenPos()
	print("=======Activity_9001615_RewardPanel:onInit")
	self.nodeCommonPopBox = SoraDGetChildByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitle(i18n("Smelt_text_20"))
	self.textTips = SoraDGetChildByName(self, "Text_tips1")
	self.textTips2 = SoraDGetChildByName(self, "Text_tips2")
	self.textTips3 = SoraDGetChildByName(self, "Text_tips3")
	self.textTips4 = SoraDGetChildByName(self, "Text_tips4")
	self.textTips3:setString(i18n("Smelt_text_22"))
	self.textTips4:setString(i18n("Smelt_text_21"))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.nodeAward2 = SoraDGetChildByName(self, "Node_Award2")
	self.nodeAward:setVirtual()
	self.nodeAward:setItemRenderer(handler(self, self.onItemRenderer1))
	self.nodeAward2:setVirtual()
	self.nodeAward2:setItemRenderer(handler(self, self.onItemRenderer2))
	self.tmpItem = SoraDGetChildByName(self, "Node_Item")
end
function Activity_9001615_RewardPanel:onShow()
	print("=======Activity_9001615_RewardPanel:onShow")
end
function Activity_9001615_RewardPanel:onItemRenderer1(index, obj)
	local data = self.rewards1[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001615_RewardPanel:onItemRenderer2(index, obj)
	local data = self.rewards2[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001615_RewardPanel:initData(rewards)
	local nowValue = activity_9001615_Ctrl:getValue()
	local costValue = rewards.cost
	self.textTips3:setVisible(nowValue < costValue)
	self.textTips4:setVisible(nowValue >= costValue)
	activity_9001615_Ctrl = nil
	activity_9001615_Ctrl, activity_9001615_Ctrl, (nil).num = nil, nil, costValue
	;(nil).num, (nil).color = nil, "#00BE1E"
	self.textTips:setString(i18n_html("Smelt_text_13", nil, nil))
	activity_9001615_Ctrl = i18n_html("Smelt_text_13", nil, nil)
	activity_9001615_Ctrl, activity_9001615_Ctrl, i18n_html("Smelt_text_13", nil, nil).num = i18n_html("Smelt_text_13", nil, nil)
	i18n_html("Smelt_text_13", nil, nil).num, i18n_html("Smelt_text_13", nil, nil).color = i18n_html("Smelt_text_13", nil, nil)
	self.textTips2:setString(i18n_html("Smelt_text_12", i18n_html("Smelt_text_13", nil, nil)))
	_UPVALUE2_ = i18n_html("Smelt_text_12", i18n_html("Smelt_text_13", nil, nil))
	i18n_html("Smelt_text_12", i18n_html("Smelt_text_13", nil, nil))[1] = "id"
	i18n_html("Smelt_text_12", i18n_html("Smelt_text_13", nil, nil))[2] = "count"
	self.rewards1 = serviceFunctions.tableFormat(rewards.reward1, i18n_html("Smelt_text_12", i18n_html("Smelt_text_13", nil, nil)))
	self.nodeAward:setNumItems(#self.rewards1)
	_UPVALUE2_ = #self.rewards1
	;(#self.rewards1)[1] = "id"
	;(#self.rewards1)[2] = "count"
	self.rewards2 = serviceFunctions.tableFormat(rewards.reward2, #self.rewards1)
	self.nodeAward2:setNumItems(#self.rewards2)
end
function Activity_9001615_RewardPanel:onBtnGo(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close()
	end
end
return Activity_9001615_RewardPanel
