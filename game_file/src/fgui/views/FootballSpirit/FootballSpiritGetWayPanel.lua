local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FootballSpiritGetWayPanel = class("FootballSpiritGetWayPanel", baseFguiPanel)
function FootballSpiritGetWayPanel:ctor(...)
	self.super.ctor(self, ...)
	print("FootballSpiritGetWayPanel:ctor", self.viewName)
end
function FootballSpiritGetWayPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function FootballSpiritGetWayPanel:onInit()
	print("=======FootballSpiritGetWayPanel:onInit")
	self.itemID = 858801
	self.fields.bg:setString(i18n("common_text_4342"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_name:fixPos()
	self.fields.Text_num:fixPos()
	self.fields.icon:fixPos()
	self.fields.n4:fixPos()
end
function FootballSpiritGetWayPanel:onItemRenderer(index, obj)
	obj:initData(self.wayCfg[index + 1], self)
end
function FootballSpiritGetWayPanel:onShow()
	print("=======FootballSpiritGetWayPanel:onShow")
	self.fields.icon:setSpriteFrame(publicRead.getIcon(self.itemID))
	self.fields.Text_name:setString(publicRead.getName(self.itemID))
	_ENV = publicRead.getName(self.itemID)
	publicRead.getName(self.itemID).count = backpackCtrl:getItemCount(self.itemID)
	self.fields.Text_num:setString(i18n("common_text_1377", publicRead.getName(self.itemID)))
	_ENV, _ENV = self.fields.Text_num, self.fields.Text_num.setString
	_ENV, self.fields.Text_num.setString[1], self.fields.Text_num.wType = self.fields.Text_num, self.fields.Text_num, 1
	self.fields.Text_num.wType = 2
	_ENV, self.fields.Text_num.setString[2], self.fields.Text_num.activityID = self.fields.Text_num, self.fields.Text_num, gActivityTimeActivityID.FOOTBALL_KING_ACTIVITY
	self.fields.Text_num.wType = 2
	_ENV, self.fields.Text_num.setString[3], self.fields.Text_num.activityID = self.fields.Text_num, self.fields.Text_num, gActivityTimeActivityID.FOOTBALL_CLOTHES_ACTIVITY
	self.fields.Text_num.wType = 2
	_ENV, self.fields.Text_num.setString[4], self.fields.Text_num.activityID = self.fields.Text_num, self.fields.Text_num, gActivityTimeActivityID.FOOTBALL_CHAMPION_ACTIVITY
	self.fields.Text_num.wType = 2
	_ENV, self.fields.Text_num.setString[5], self.fields.Text_num.activityID = self.fields.Text_num, self.fields.Text_num, gActivityTimeActivityID.PITCH_AGAINST_HEAD_ACTIVITY
	self.fields.Text_num.wType = 2
	self.wayCfg, self.fields.Text_num.setString[6], self.fields.Text_num.activityID = self.fields.Text_num.setString, self.fields.Text_num, gActivityTimeActivityID.ONE_GOAL_TO_FAME_ACTIVITY
	self.fields.list:setNumItems(#self.wayCfg)
end
return FootballSpiritGetWayPanel
