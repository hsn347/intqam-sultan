local baseComponent = require("fgui.base.baseComponent")
local Com_Stage = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001573_Read = include("activity_9001573_Read")
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
fgui.register_extension("ui://Activity_9001573/Com_Stage", Com_Stage)
function Com_Stage:onInit()
	self:fixChildrenPos()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRederer))
	self.stageConfig = activity_9001573_Read.getRewardsByType(1)
	dump(self.stageConfig, "self.stageConfig")
	self.fields.List_reward:setNumItems(#self.stageConfig)
	self.fields.List_reward:resizeToFit(#self.stageConfig)
	local bar_v = self.fields.Com_Bar:getChild("bar_v")
	self.barHeight = self.fields.Com_Bar:getChild("bg"):getHeight() - 3
	bar_v:setHeight(self.barHeight)
	bar_v:getChild("icon"):setWidth(self.barHeight + 19)
	self.fields.Com_Bar:setMax(100)
	self.fields.Com_Bar:setValue(self:getProgressValue())
	self:getScrollPane():setPercY(self:getProgressValue() / 100, true)
end
function Com_Stage:onShow()
end
function Com_Stage:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001573_POINT_REWARD", handler(self, self.msgRefreshView))
end
function Com_Stage:msgRefreshView(target, data)
	self.fields.List_reward:setNumItems(#self.stageConfig)
end
function Com_Stage:onItemRederer(index, target)
	target:initData(self.stageConfig[index + 1], index + 1)
end
function Com_Stage:getProgressValue()
	local value = activity_9001573_Ctrl:getMyPoint()
	local key = "point"
	local offsetY = 0
	for i, v in ipairs(self.stageConfig) do
		if value >= v[key] then
			if i == 1 then
				offsetY = offsetY + 44
			else
				offsetY = offsetY + 126
			end
		else
			local base = 126
			local lastNum = 0
			if i == 1 then
				base = 44
			else
				lastNum = self.stageConfig[i - 1][key]
			end
			offsetY = offsetY + base * (value - lastNum) / (v[key] - lastNum)
			break
		end
	end
	print("self:getProgressValue()", offsetY)
	return offsetY / self.barHeight * 100
end
function Com_Stage:updateScrolll(...)
	self.fields.List_reward:setNumItems(#self.stageConfig)
end
return Com_Stage
