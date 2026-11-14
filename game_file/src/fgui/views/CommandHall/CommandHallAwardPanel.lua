local commandHallRead = include("commandHallRead")
local commandHallUtil = include("commandHallUtil")
local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommandHallAwardPanel = class("CommandHallAwardPanel", baseFguiPanel)
function CommandHallAwardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommandHallAwardPanel:ctor", self.viewName)
end
function CommandHallAwardPanel:onInit()
	print("=======CommandHallAwardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("decrypt_text_03"))
	local fields = fguiHelper.get_fields(self.fields.Com_awardTitle)
	fields.title1:setString(i18n("commandhall_text_99"))
	fields.title2:setString(i18n("commandhall_text_11"))
	fields.title3:setString(i18n("common_text_3343"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.List_reward:setVirtual()
	self.rewards = commandHallRead.getRabellegionRewards()
	self.fields.List_reward:setNumItems(#self.rewards)
	local order = commandHallCtrl:getArmyGroupID()
	if 1 < order then
		local jump = math.min(order, #self.rewards)
		self.fields.List_reward:scrollToView(jump - 1)
	end
	local maxNum = commandHallRead.getCommandLvMaxNum(order)
	local taskID = commandHallRead.getTaskIDByOrder(order)
	local relevanceTask = commandHallRead.getTaskRelevanceTask(taskID)
	local fixedTask = commandHallRead.getFixedTask(order)
	local taskCount = maxNum + #relevanceTask + #fixedTask
	_ENV = handler(self, self.onRewardItemRenderer)
	handler(self, self.onRewardItemRenderer).num = taskCount
	self.fields.Text_taskCount:setString(i18n("commandhall_text_102", handler(self, self.onRewardItemRenderer)))
	if not SoraDFIsRA() then
		self.fields.Com_awardTitle:fixChildrenPos()
	end
end
function CommandHallAwardPanel:onShow()
	print("=======CommandHallAwardPanel:onShow")
end
function CommandHallAwardPanel:onRewardItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local fields = obj.fields
	fields.Image_line:setVisible(index % 2 == 0)
	if data.isCirculate then
		fields.Text_index:setString(tostring(data.index - 1) .. "+")
	else
		fields.Text_index:setString(data.index)
	end
	if not data.killReward then
		local _ENV, killReward = data.killReward, data.killReward
	end
	fields.List_reward1:setItemRenderer(function(_index, obj)
		local _item = killReward[_index + 1]
		obj:initData(_item.id, _item.count)
	end)
	fields.List_reward1:setNumItems(#killReward)
	if not data.victoryReward then
		local _ENV, victoryReward = data.victoryReward, data.victoryReward
	end
	fields.List_reward2:setItemRenderer(function(_index, obj)
		local _item = victoryReward[_index + 1]
		obj:initData(_item.id, _item.count)
	end)
	fields.List_reward2:setNumItems(#victoryReward)
end
return CommandHallAwardPanel
