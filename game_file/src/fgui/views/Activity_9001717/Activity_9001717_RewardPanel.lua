local activity_9001717_Read = include("activity_9001717_Read")
local activity_9001717_Ctrl = SoraDGetCtrl("activity_9001717_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001717_RewardPanel = class("Activity_9001717_RewardPanel", baseFguiPanel)
function Activity_9001717_RewardPanel:ctor(...)
	self.isLRU = true
	Activity_9001717_RewardPanel.super.ctor(self, ...)
	print("Activity_9001717_RewardPanel:ctor", self.viewName)
end
function Activity_9001717_RewardPanel:onInit()
	print("=======Activity_9001717_RewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Bubble_island_rebuild_text_13"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_tip:setString(i18n("Bubble_island_rebuild_text_51"))
end
function Activity_9001717_RewardPanel:endShow()
	print("=======Activity_9001717_RewardPanel:endShow")
	local totalScore = activity_9001717_Ctrl:getTotalScore()
	local lv = activity_9001717_Read.getAllianceLv(totalScore)
	self.curLv = lv
	local expMax = activity_9001717_Read.getAllianceLvExpMax(lv + 1)
	_ENV = nil
	;(nil).val = fguiHelper.getColorString("#E1DF5C", lv)
	local lvStr = i18n("flames_dunes_text77", nil)
	self.fields.Text_lv:setString(lvStr)
	_ENV = lv
	lv.num1 = string.formatnumberthousands(totalScore)
	lv.num2 = string.formatnumberthousands(expMax)
	self.fields.Text_score:setString(i18n("Ramadan_League_text_18", lv))
	self.allianceConfig = activity_9001717_Read.getAllianceConfig()
	self.fields.List:setNumItems(#self.allianceConfig)
	if self.curLv > 0 then
		self.fields.List:scrollToView(self.curLv - 1)
	end
end
function Activity_9001717_RewardPanel:onItemRenderer(index, obj)
	local cfg = self.allianceConfig[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	_ENV = nil
	_ENV = nil
	;(nil).lv = cfg.level
	;(nil).var1 = i18n("common_text_2838", nil)
	_ENV = nil
	;(nil).score = cfg.point
	;(nil).var2 = i18n("krone_text_15", nil)
	_fields.Text_level:setString(i18n("%{var1}(%{var2})", nil))
	_UPVALUE2_ = i18n("%{var1}(%{var2})", nil)
	i18n("%{var1}(%{var2})", nil)[1] = "id"
	i18n("%{var1}(%{var2})", nil)[2] = "count"
	local rewards = serviceFunctions.tableFormat(cfg.reward, i18n("%{var1}(%{var2})", nil))
	_fields.List:setItemRenderer(function(_index, _obj)
		local reward = rewards[_index + 1]
		local giftType = reward.id
		_obj:setIcon(activity_9001717_Read.getGiftIcon(giftType))
		_obj:setNum(reward.count)
		_obj:setQuality(giftType)
		_obj:setSpecialNum()
		_obj:setClickCallback(function(...)
			_ENV = nil
			;(nil).title = activity_9001717_Read.getGiftName(giftType)
			;(nil).rewards = activity_9001717_Read.getGiftRewards(giftType)
			;(nil).tip = i18n("Bubble_island_rebuild_text_15")
			uiManager:show("CommonPopBox3", nil)
		end)
	end)
	_fields.List:setNumItems(#rewards)
	_fields.List:setScrollEnable(6 < #rewards)
	local c1 = obj:getController("c1")
	if self.curLv == cfg.level then
		c1:setSelectedIndex(1)
	else
		c1:setSelectedIndex(0)
	end
end
return Activity_9001717_RewardPanel
