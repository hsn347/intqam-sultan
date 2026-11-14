local activity_9001571_Ctrl = SoraDGetCtrl("activity_9001571_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_AwardItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001571/Com_AwardItem", Com_AwardItem)
fgui.register_extension("ui://Activity_9001571/Com_AwardItem2", Com_AwardItem)
function Com_AwardItem:onInit()
end
function Com_AwardItem:onShow()
end
function Com_AwardItem:initData(data, index, curLv)
	local state1 = activity_9001571_Ctrl:getRewardState(1, data.Lv)
	local state2 = activity_9001571_Ctrl:getRewardState(2, data.Lv)
	print("Com_AwardItemstate", state, data.Lv)
	self.fields.Com_Item2:initData(data.LvReward2[1], data.LvReward2[2], state2, not activity_9001571_Ctrl:isRewardUnlock())
	self.fields.Com_Item1:initData(data.LvReward1[1], data.LvReward1[2], state1, false)
	if curLv == data.Lv then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.title:setString("lv\n" .. data.Lv)
end
function Com_AwardItem:initPreData(data)
	if data then
		self.fields.Com_Item2:initData(data.LvReward2[1], data.LvReward2[2], gBtnTargetStatusDef.GO, false)
		self.fields.Com_Item1:initData(data.LvReward1[1], data.LvReward1[2], gBtnTargetStatusDef.GO, false)
		self.fields.title:setString("lv\n" .. data.Lv)
	end
end
return Com_AwardItem
