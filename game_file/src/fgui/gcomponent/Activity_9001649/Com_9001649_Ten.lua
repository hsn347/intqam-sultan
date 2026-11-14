local baseComponent = require("fgui.base.baseComponent")
local Com_9001649_Ten = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001649_Ctrl = SoraDGetCtrl("activity_9001649_Ctrl")
local activity_9001649_Read = include("activity_9001649_Read")
local publicRead = include("publicRead")
fgui.register_extension("ui://Activity_9001649/Com_9001649_Ten", Com_9001649_Ten)
_ENV = fgui.register_extension
fgui.register_extension.GOLD = 1
local fgui.register_extension.SILVER, gMineType = 2, fgui.register_extension
function Com_9001649_Ten:onInit()
	self.fields.list:setItemRenderer(handler(self, self.onItemRederer))
	self.itemData = activity_9001649_Read.getItemCfg()
	self.fields.gold:fixPos()
	self.fields.silver:fixPos()
	self.fields.gold:fixChildrenPos(true)
	self.fields.silver:fixChildrenPos(true)
end
function Com_9001649_Ten:onShow()
end
function Com_9001649_Ten:initData(rewards)
	dump(rewards, "rewards")
	local gold = 0
	local silver = 0
	for i, v in ipairs(rewards) do
		if v.mineType == gMineType.GOLD then
			gold = gold + 1
		else
			silver = silver + 1
		end
	end
	_ENV = nil
	;(nil).item = publicRead.getName(self.itemData.expend[1])
	;(nil).num = self.itemData.expend[2] * #rewards
	self.fields.text_des:setString(i18n("explore_ore_text15", nil))
	self.fields.text_des2:setString(i18n("explore_ore_text16"))
	self.fields.gold:setTitle("X" .. gold)
	self.fields.silver:setTitle("X" .. silver)
	self.rewards = rewards
	self.fields.list:setNumItems(#rewards)
	self.fields.list:setHeight(math.ceil(#rewards / 5) * 160)
end
function Com_9001649_Ten:onItemRederer(index, obj)
	obj:initData(self.rewards[index + 1], index + 1)
end
return Com_9001649_Ten
