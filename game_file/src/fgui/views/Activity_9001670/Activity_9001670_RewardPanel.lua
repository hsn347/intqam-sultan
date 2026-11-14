local activity_9001670_Ctrl = SoraDGetCtrl("activity_9001670_Ctrl")
local activity_9001670_Read = include("activity_9001670_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001670_RewardPanel = class("Activity_9001670_RewardPanel", baseFguiPanel)
function Activity_9001670_RewardPanel:ctor(...)
	Activity_9001670_RewardPanel.super.ctor(self, ...)
	print("Activity_9001670_RewardPanel:ctor", self.viewName)
end
function Activity_9001670_RewardPanel:onInit()
	print("=======Activity_9001670_RewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Bubble_island_rebuild_text_13"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.Text_tip:setString(i18n("Bubble_island_rebuild_text_51"))
end
function Activity_9001670_RewardPanel:onShow()
	print("=======Activity_9001670_RewardPanel:onShow")
	local totalScore = activity_9001670_Ctrl:getTotalScore()
	local lv = activity_9001670_Read.getAllianceLv(totalScore)
	self.curLv = lv
	local expMax = activity_9001670_Read.getAllianceLvExpMax(lv + 1)
	_ENV = nil
	_ENV = nil
	;(nil).color = "#E1DF5C"
	;(nil).lv = SoraDWrapHtmlTagByStyle(lv, nil)
	local lvStr = i18n("Bubble_island_rebuild_text_14", nil)
	self.fields.Text_lv:setString(lvStr)
	local scoreStr1 = i18n("Bubble_island_rebuild_text_37")
	_ENV = lv
	lv.member = string.formatnumberthousands(totalScore)
	lv.total = string.formatnumberthousands(expMax)
	local scoreStr2 = i18n("common_text_155", lv)
	_ENV = expMax
	expMax.color = "#E1DF5C"
	local scoreStr = scoreStr1 .. SoraDWrapHtmlTagByStyle(scoreStr2, expMax)
	self.fields.Text_score:setString(scoreStr)
	self.allianceConfig = activity_9001670_Read.getAllianceConfig()
	self.fields.List:setNumItems(#self.allianceConfig)
	if self.curLv > 0 then
		self.fields.List:scrollToView(self.curLv - 1)
	end
end
function Activity_9001670_RewardPanel:onItemRenderer(index, obj)
	local cfg = self.allianceConfig[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	_ENV = nil
	;(nil).lv = cfg.level
	_fields.Text_level:setString(i18n("Bubble_island_rebuild_text_54", nil))
	_UPVALUE2_ = i18n("Bubble_island_rebuild_text_54", nil)
	i18n("Bubble_island_rebuild_text_54", nil)[1] = "id"
	i18n("Bubble_island_rebuild_text_54", nil)[2] = "count"
	local rewards = serviceFunctions.tableFormat(cfg.reward, i18n("Bubble_island_rebuild_text_54", nil))
	_fields.List:setItemRenderer(function(_index, _obj)
		local reward = rewards[_index + 1]
		local giftType = reward.id
		_obj:setIcon(activity_9001670_Read.getGiftIcon(giftType))
		_obj:setNum(reward.count)
		_obj:setQuality(giftType)
		_obj:setSpecialNum()
		_obj:setClickCallback(function(...)
			_ENV = nil
			;(nil).title = activity_9001670_Read.getGiftName(giftType)
			;(nil).rewards = activity_9001670_Read.getGiftRewards(giftType)
			;(nil).tip = i18n("Bubble_island_rebuild_text_56")
			uiManager:show("CommonPopBox3", nil)
		end)
	end)
	_fields.List:setNumItems(#rewards)
	local c1 = obj:getController("c1")
	if self.curLv == cfg.level then
		c1:setSelectedIndex(1)
	else
		c1:setSelectedIndex(0)
	end
end
return Activity_9001670_RewardPanel
