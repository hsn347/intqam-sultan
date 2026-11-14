local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
local activity_9001565_Ctrl = SoraDGetCtrl("activity_9001565_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_AwardItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BraqueTest/Com_AwardItem", Com_AwardItem)
fgui.register_extension("ui://BraqueTest/Com_AwardItem2", Com_AwardItem)
function Com_AwardItem:onInit()
end
function Com_AwardItem:onShow()
end
function Com_AwardItem:initData(data, index, curLv)
	local state1 = warOrderCtrl:getRewardState(1, data.lv)
	local state2 = warOrderCtrl:getRewardState(2, data.lv)
	local state3 = warOrderCtrl:getRewardState(3, data.lv)
	print("Com_AwardItemstate", data.lv, state1, state2, state3)
	self.fields.Com_Item3:initData(data.goldAward2[1], data.goldAward2[2], state3, not warOrderCtrl:isRewardUnlock(3))
	self.fields.Com_Item2:initData(data.goldAward1[1], data.goldAward1[2], state2, not warOrderCtrl:isRewardUnlock(2))
	self.fields.Com_Item1:initData(data.bronzeAward[1], data.bronzeAward[2], state1, false)
	if curLv == data.lv or data.lvMax and curLv >= data.lvMax then
		self.controllers.c1:setSelectedIndex(2)
	else
		self.controllers.c1:setSelectedIndex(index % 2)
	end
	if data.lvMax then
		self.fields.title:setString("lv\n" .. data.lvMax .. "+")
	else
		self.fields.title:setString("lv\n" .. data.lv)
	end
end
function Com_AwardItem:initData_9001565(data, index, curLv)
	local state1 = activity_9001565_Ctrl:getRewardState(1, data.lv)
	local state2 = activity_9001565_Ctrl:getRewardState(2, data.lv)
	print("Com_AwardItemstate", data.lv, state1, state2)
	self.fields.Com_Item2:initData(data.goldAward1[1], data.goldAward1[2], state2, not activity_9001565_Ctrl:isRewardUnlock(2))
	self.fields.Com_Item1:initData(data.bronzeAward[1], data.bronzeAward[2], state1, false)
	if curLv == data.lv or data.lvMax and curLv >= data.lvMax then
		self.controllers.c1:setSelectedIndex(2)
	else
		self.controllers.c1:setSelectedIndex(index % 2)
	end
	if data.lvMax then
		self.fields.title:setString("lv\n" .. data.lvMax .. "+")
	else
		self.fields.title:setString("lv\n" .. data.lv)
	end
	local unlockLv = activity_9001565_Ctrl:getUnlockBuffLv()
	if data.lv == unlockLv then
		self.controllers.c2:setSelectedIndex(1)
		self.fields.Text_unlock:setString(i18n("MagiclampDecree_05"))
	else
		self.controllers.c2:setSelectedIndex(0)
	end
end
function Com_AwardItem:initData_9001683(activityID, data, index, curLv)
	local curCtrl = warOrderCtrl:getCurCtrl(activityID)
	local state1 = curCtrl:getRewardState(1, data.lv)
	local state2 = curCtrl:getRewardState(2, data.lv)
	print("Com_AwardItemstate", data.lv, state1, state2)
	self.fields.Com_Item2:initData(data.goldAward1[1], data.goldAward1[2], state2, not curCtrl:isRewardUnlock(2))
	self.fields.Com_Item1:initData(data.bronzeAward[1], data.bronzeAward[2], state1, false)
	if curLv == data.lv or data.lvMax and curLv >= data.lvMax then
		self.controllers.c1:setSelectedIndex(2)
	else
		self.controllers.c1:setSelectedIndex(index % 2)
	end
	if data.lvMax then
		self.fields.title:setString("lv\n" .. data.lvMax .. "+")
	else
		self.fields.title:setString("lv\n" .. data.lv)
	end
end
function Com_AwardItem:initActivityData(activityID, ...)
	if activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY then
		self:initData(...)
	elseif activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		self:initData_9001683(activityID, ...)
	elseif activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		self:initData_9001683(activityID, ...)
	else
		self:initData_9001565(...)
	end
end
return Com_AwardItem
