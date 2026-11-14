local activity_9001625_Read = include("activity_9001625_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001631_RewardPanel = class("Activity_9001631_RewardPanel", baseFguiPanel)
function Activity_9001631_RewardPanel:ctor(...)
	Activity_9001631_RewardPanel.super.ctor(self, ...)
	print("Activity_9001631_RewardPanel:ctor", self.viewName)
end
function Activity_9001631_RewardPanel:onInit()
	print("=======Activity_9001631_RewardPanel:onInit")
	local feastId = self.param and self.param.feastId or 1
	if not self.param or not self.param.cfg then
		_ENV = self.param.cfg
		self.param.cfg.reward, _ENV, self.param.cfg.point = nil, nil, 0
		local cfg = self.param.cfg
	end
	_ENV = nil
	;(nil).var1 = feastId
	self.fields.Panel_bg:setString(i18n("activity_feastLv_name", nil))
	local c_lv = self.fields.Com_feast:getController("c_lv")
	c_lv:setSelectedIndex(feastId - 1)
	local point = activity_9001625_Read.getFeastPoint(cfg)
	self.fields.Text_tip1:setString(i18n("preparing_feast_text4"))
	_ENV = i18n("preparing_feast_text4")
	i18n("preparing_feast_text4").point = string.formatnumberthousands(point)
	self.fields.Text_tip2:setString(i18n("preparing_feast_text3", i18n("preparing_feast_text4")))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.itemList = activity_9001625_Read.getFeastReward(cfg)
	self.fields.List:setNumItems(#self.itemList)
	if not SoraDFIsRA() then
		self.fields.Com_feast:fixPos()
		self.fields.Text_tip1:fixPos()
	end
end
function Activity_9001631_RewardPanel:onShow()
	print("=======Activity_9001631_RewardPanel:onShow")
end
function Activity_9001631_RewardPanel:onItemRenderer(index, obj)
	local item = self.itemList[index + 1]
	_UPVALUE0_ = nil
	;(nil).index = index
	obj:initData(item, nil)
end
return Activity_9001631_RewardPanel
