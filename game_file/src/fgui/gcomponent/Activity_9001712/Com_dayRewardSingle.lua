local baseComponent = require("fgui.base.baseComponent")
local Com_dayRewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001712/Com_dayRewardSingle", Com_dayRewardSingle)
function Com_dayRewardSingle:onInit()
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
end
function Com_dayRewardSingle:onShow()
end
function Com_dayRewardSingle:itemRenderer_List(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.itemId, data.num)
end
function Com_dayRewardSingle:initData(index, data, isStage)
	self.rewards, _ENV = nil, nil
	if not isStage then
		_ENV = nil
		;(nil).num = data.day
		self.fields.Text_name:setString(i18n("anniversary_ten_daily_11", nil))
		for i = 1, #data.dailyReward, 3 do
			local itemId = data.dailyReward[i]
			local num = data.dailyReward[i + 1]
			_ENV = i18n("anniversary_ten_daily_11", nil)
			i18n("anniversary_ten_daily_11", nil).itemId = itemId
			i18n("anniversary_ten_daily_11", nil).num = num
			table.insert(self.rewards, i18n("anniversary_ten_daily_11", nil))
		end
	else
		_ENV = data.dailyReward[i]
		data.dailyReward[i].num = data.day
		self.fields.Text_name:setString(i18n("anniversary_ten_daily_08", data.dailyReward[i]))
		for i = 1, #data.stageReward, 2 do
			local itemId = data.stageReward[i]
			local num = data.stageReward[i + 1]
			_ENV = i18n("anniversary_ten_daily_08", data.dailyReward[i])
			i18n("anniversary_ten_daily_08", data.dailyReward[i]).itemId = itemId
			i18n("anniversary_ten_daily_08", data.dailyReward[i]).num = num
			table.insert(self.rewards, i18n("anniversary_ten_daily_08", data.dailyReward[i]))
		end
	end
	self.fields.List:setNumItems(#self.rewards)
	self.controllers.ctrlLight:setSelectedIndex(index % 2 == 1 and 0 or 1)
end
return Com_dayRewardSingle
