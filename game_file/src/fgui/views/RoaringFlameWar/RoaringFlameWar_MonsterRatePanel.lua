local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameWar_MonsterRatePanel = class("RoaringFlameWar_MonsterRatePanel", baseFguiPanel)
function RoaringFlameWar_MonsterRatePanel:ctor(...)
	self.isLRU = true
	RoaringFlameWar_MonsterRatePanel.super.ctor(self, ...)
	print("RoaringFlameWar_MonsterRatePanel:ctor", self.viewName)
	RoaringFlameWar_MonsterRatePanel = self.viewName
	_ENV, self.rateList = roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_COST_MAG", self.viewName), roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_COST_MAG", self.viewName)
	self.stateList, roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_COST_MAG", self.viewName)[1] = roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_COST_MAG", self.viewName), i18n("common_text_247")
	self.stateList, roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_COST_MAG", self.viewName)[2] = roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_COST_MAG", self.viewName), i18n("common_text_246")
	self.stateList, roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_COST_MAG", self.viewName)[3] = roaringFlameWarRead.getConstValueArray("FLAMES_DUNES_COST_MAG", self.viewName), i18n("common_text_246")
end
function RoaringFlameWar_MonsterRatePanel:onInit()
	print("=======RoaringFlameWar_MonsterRatePanel:onInit")
	self.fields.Panel_bg:setString(i18n("flames_dunes_text176"))
	self.fields.Label_rate:setString(i18n("flames_dunes_text243"))
	self.fields.ListRate:setItemRenderer(handler(self, self.onItemRateRenderer))
	self.fields.ListRate:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItemRate))
	self.fields.ListRate:setNumItems(#self.rateList)
	self.fields.Label_state:setString(i18n("flames_dunes_text182"))
	self.fields.ListState:setItemRenderer(handler(self, self.onItemStateRenderer))
	self.fields.ListState:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItemState))
	self.fields.ListState:setNumItems(#self.stateList)
	self.fields.Button_close:setString(i18n("common_text_204"))
end
function RoaringFlameWar_MonsterRatePanel:endShow()
	print("=======RoaringFlameWar_MonsterRatePanel:endShow")
	local rate = self.param and self.param.rate or 1
	local index = table.indexof(self.rateList, rate) or 1
	local selectIndex = index - 1
	self.fields.ListRate:setSelectedIndex(selectIndex)
	self:updateTextRateDes()
	local isOpen = roaringFlameWarUtil.getMonsterIsOpenRate()
	local selectIndex = isOpen and 1 or 0
	self.fields.ListState:setSelectedIndex(selectIndex)
end
function RoaringFlameWar_MonsterRatePanel:onItemRateRenderer(index, obj)
	local rate = self.rateList[index + 1]
	obj:setString("x" .. rate)
end
function RoaringFlameWar_MonsterRatePanel:onClickItemRate(EventContext)
	SoraDPlaySound()
	self:updateTextRateDes()
	local rate = self:getSelectRate()
	roaringFlameWarUtil.setMonsterRate(rate)
	local callback = self.param and self.param.callback
	if callback then
		callback(rate)
	end
end
function RoaringFlameWar_MonsterRatePanel:onItemStateRenderer(index, obj)
	local stateStr = self.stateList[index + 1]
	obj:setString(stateStr)
end
function RoaringFlameWar_MonsterRatePanel:onClickItemState(EventContext)
	SoraDPlaySound()
	local selectIndex = self.fields.ListState:getSelectedIndex()
	local isOpen = selectIndex == 1
	roaringFlameWarUtil.setMonsterIsOpenRate(isOpen)
	if isOpen then
		local rate = self:getSelectRate()
		roaringFlameWarUtil.setMonsterRate(rate)
	end
end
function RoaringFlameWar_MonsterRatePanel:getSelectRate(...)
	local selectIndex = self.fields.ListRate:getSelectedIndex()
	local rate = self.rateList[selectIndex + 1] or 1
	return rate
end
function RoaringFlameWar_MonsterRatePanel:updateTextRateDes(...)
	local rate = self:getSelectRate()
	local physical = HP_MIN_MONSTER_CHEST * rate
	_ENV = nil
	;(nil).color = "#70C723"
	local val1 = SoraDWrapHtmlTagByStyle(physical, nil)
	_ENV = nil
	;(nil).color = "#70C723"
	local val2 = SoraDWrapHtmlTagByStyle(rate, nil)
	_ENV = nil
	;(nil).val1 = val1
	;(nil).val2 = val2
	local desStr = i18n("flames_dunes_text181", nil)
	self.fields.Text_rateDes:setString(desStr)
end
return RoaringFlameWar_MonsterRatePanel
