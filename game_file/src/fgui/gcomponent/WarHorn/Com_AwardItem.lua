local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
local warHornCtrl = SoraDGetCtrl("warHornCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_AwardItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarHorn/Com_AwardItem", Com_AwardItem)
function Com_AwardItem:onInit()
	self.fields.n40:fixPos()
	self.fields.Com_Item1:fixPos()
	self.fields.Com_Item2:fixPos()
	self.fields.Com_Item3:fixPos()
end
function Com_AwardItem:onShow()
end
function Com_AwardItem:initData(data, index, curLv)
	local state1 = warHornCtrl:getRewardState(1, data.lv)
	local state2 = warHornCtrl:getRewardState(2, data.lv)
	local state3 = warHornCtrl:getRewardState(3, data.lv)
	print("Com_AwardItemstate", state, data.lv)
	self.fields.Com_Item3:initData(data.goldAward2[1], data.goldAward2[2], state3, not warHornCtrl:isRewardUnlock(3))
	self.fields.Com_Item2:initData(data.goldAward1[1], data.goldAward1[2], state2, not warHornCtrl:isRewardUnlock(2))
	self.fields.Com_Item1:initData(data.bronzeAward[1], data.bronzeAward[2], state1, false)
	if curLv == data.lv or data.lvMax and curLv >= data.lvMax then
		self.controllers.c1:setSelectedIndex(2)
	else
		self.controllers.c1:setSelectedIndex(index % 2)
	end
	if data.lvMax then
		self.controllers.c2:setSelectedIndex(1)
		self.fields.Text_title:setString(data.lvMax)
		self.fields.Text_title:setPositionX(SoraDFIsRA() and 465 or 40)
	else
		self.controllers.c2:setSelectedIndex(0)
		self.fields.Text_title:setString(data.lv)
		self.fields.Text_title:setPositionX(SoraDFIsRA() and 475 or 50)
	end
end
return Com_AwardItem
