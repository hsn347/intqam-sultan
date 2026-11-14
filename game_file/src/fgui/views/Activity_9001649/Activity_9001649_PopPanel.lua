local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001649_PopPanel = class("Activity_9001649_PopPanel", baseFguiPanel)
local activity_9001649_Ctrl = SoraDGetCtrl("activity_9001649_Ctrl")
local activity_9001649_Read = include("activity_9001649_Read")
function Activity_9001649_PopPanel:ctor(...)
	Activity_9001649_PopPanel.super.ctor(self, ...)
	print("Activity_9001649_PopPanel:ctor", self.viewName)
	self.debug = true
end
function Activity_9001649_PopPanel:onInit()
	print("=======Activity_9001649_PopPanel:onInit")
	local itemCfg = activity_9001649_Read.getItemCfg()
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	_ENV = i18n("decrypt_text_03")
	i18n("decrypt_text_03").times = activity_9001649_Ctrl:getLuckyNum()
	self.fields.text_lucky:setString(i18n("explore_ore_text22", i18n("decrypt_text_03")))
	_ENV = i18n("explore_ore_text22", i18n("decrypt_text_03"))
	i18n("explore_ore_text22", i18n("decrypt_text_03")).times = itemCfg.maxlucky
	self.fields.text_des:setString(i18n("explore_ore_text17", i18n("explore_ore_text22", i18n("decrypt_text_03"))))
	self.fields.list:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.text_lucky:fixPos()
	self.fields.text_des:fixPos()
	self.fields.n8:fixPos()
	self.fields.n9:fixPos()
	self.fields.n8:fix()
	self.fields.n9:fix()
end
function Activity_9001649_PopPanel:onShow()
	print("=======Activity_9001649_PopPanel:onShow")
	self:updateView()
end
function Activity_9001649_PopPanel:updateView()
	local activity_9001649_Read, rewards
	local activity_9001649_Read, itemMaps
	local rewardCfgs = activity_9001649_Read.getRewardConfig()
	for i, v in ipairs(rewardCfgs) do
		if v.oretype == 1 then
			dump(v.reward, "Activity_9001649_PopPanel:updateView()")
			if v.Itemorder == 1 then
				activity_9001649_Read = v.Itemorder
				v.Itemorder.title = i18n("explore_ore_text18")
				rewards[1], v.Itemorder.reward = v.Itemorder, v.reward
			else
				for i2, v2 in ipairs(v.reward) do
					itemMaps[v2.id] = itemMaps[v2.id] or v2.count
					itemMaps[v2.id] = itemMaps[v2.id] < v2.count and v2.count or itemMaps[v2.id]
				end
			end
		end
	end
	local activity_9001649_Read, rewrads2 = (for generator), ipairs(rewardCfgs)
	for k, v in pairs(itemMaps) do
		activity_9001649_Read = nil
		;(nil).id = k
		;(nil).count = v
		table.insert(rewrads2, nil)
	end
	table.sort(rewrads2, function(a, b)
		return a.id > b.id
	end)
	activity_9001649_Read = table.sort
	table.sort.title = i18n("cityUp_title_03")
	rewards[2], table.sort.reward = table.sort, rewrads2
	dump(rewards, "rewards")
	self.rewards = rewards
	self.fields.list:setNumItems(#rewards)
end
function Activity_9001649_PopPanel:onItemRederer(index, obj)
	obj:initData(self.rewards[index + 1])
end
return Activity_9001649_PopPanel
