local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SoldierRushHookPanel = class("SoldierRushHookPanel", baseFguiPanel)
function SoldierRushHookPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SoldierRushHookPanel:ctor", self.viewName)
end
function SoldierRushHookPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SoldierRushHookPanel:onInit()
	print("=======SoldierRushHookPanel:onInit")
	self.fields.Panel_bg:setString(i18n("soldier_rush_text_119"))
	self.fields.Text_cumu:setString(i18n("soldier_rush_text_111"))
	self.fields.Text_output:setString(i18n("soldier_rush_text_113"))
	self.fields.Text_extra:setString(i18n("soldier_rush_text_115"))
	self.fields.Btn_detail:addClickListener(handler(self, self.onDetailClick))
	self.fields.List_res:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_extra:setItemRenderer(handler(self, self.onExtraItemRenderer))
	self.fields.Btn_out:setString(i18n("common_text_247"))
	self.fields.Btn_out:addClickListener(handler(self, self.onCloseClick))
	self.fields.Btn_reward:setString(i18n("common_text_1146"))
	self.fields.Btn_reward:addClickListener(handler(self, self.onRewardClick))
	self.fields.Btn_out:fixPos()
	self.fields.Btn_reward:fixPos()
	soldierRushCtrl:sendAFKInit()
end
function SoldierRushHookPanel:onItemRenderer(index, obj)
	obj:initData(self.resList[index + 1])
end
function SoldierRushHookPanel:onExtraItemRenderer(index, obj)
	obj:initData(self.extraList[index + 1].id, self.extraList[index + 1].count)
end
function SoldierRushHookPanel:onShow()
	print("=======SoldierRushHookPanel:onShow")
	self:initData()
end
function SoldierRushHookPanel:initData()
	local incomeMaxTime = soldierRushRead.getConstantVal("Territory_Income_Max_Time")
	local svrReceiveTime = soldierRushCtrl:getAFKLastReceiveTime()
	local svrIncomeTime = 0
	if svrReceiveTime then
		svrIncomeTime = serviceFunctions.systemTime() - svrReceiveTime
	end
	self.fields.Timer_cumu:beginTime(math.min(incomeMaxTime, svrIncomeTime), true, false, incomeMaxTime)
	local bonus = soldierRushRead.getCastleBonus(SoraDGetCastleLv())
	soldierRushRead = SoraDGetCastleLv()
	SoraDGetCastleLv().num = fguiHelper.getColorString("#70C723", bonus / 10)
	self.fields.Text_castleBonus:setString(i18n("soldier_rush_text_114", SoraDGetCastleLv()))
	local hookRewards = soldierRushCtrl:getAFKReward()
	self.extraList, soldierRushRead, self.resList, soldierRushRead = soldierRushCtrl, soldierRushCtrl, soldierRushCtrl, soldierRushCtrl
	for k, v in pairs(hookRewards) do
		if serviceFunctions.isResourceID(tonumber(k)) then
			soldierRushRead = tonumber(k)
			tonumber(k).id = tonumber(k)
			tonumber(k).count = v
			table.insert(self.resList, tonumber(k))
		else
			soldierRushRead = tonumber(k)
			tonumber(k).id = tonumber(k)
			tonumber(k).count = v
			table.insert(self.extraList, tonumber(k))
		end
	end
	table.sort(self.resList, function(a, b)
		return a.id < b.id
	end)
	table.sort(self.extraList, function(a, b)
		return a.id < b.id
	end)
	self.fields.List_res:setNumItems(#self.resList)
	self.fields.List_extra:setNumItems(#self.extraList)
	self.fields.Btn_reward:setEnabled(0 < #self.resList or 0 < #self.extraList)
end
function SoldierRushHookPanel:onDetailClick()
	SoraDPlaySound()
	uiManager:show("SoldierRushHookDetail")
end
function SoldierRushHookPanel:onRewardClick()
	SoraDPlaySound()
	soldierRushCtrl:sendAFKReward()
	self:close()
end
function SoldierRushHookPanel:onCloseClick()
	SoraDPlaySound()
	self:close()
end
return SoldierRushHookPanel
