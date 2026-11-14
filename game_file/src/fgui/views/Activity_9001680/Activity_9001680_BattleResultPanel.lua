local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001680_BattleResultPanel = class("Activity_9001680_BattleResultPanel", baseFguiPanel)
local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
function Activity_9001680_BattleResultPanel:ctor(...)
	self.isLRU = true
	Activity_9001680_BattleResultPanel.super.ctor(self, ...)
	print("Activity_9001680_BattleResultPanel:ctor", self.viewName)
end
function Activity_9001680_BattleResultPanel:onInit()
	print("=======Activity_9001680_BattleResultPanel:onInit")
	self.fields.button_1:addClickEventListener(handler(self, self.closeSelf))
	self.fields.button_1:setTitle(i18n("common_text_204"))
	self.fields.button_2:addClickEventListener(handler(self, self.closeSelf))
	self.fields.button_2:setTitle(i18n("common_text_006"))
	self.fields.button_3:addClickEventListener(handler(self, self.reStart))
	self.fields.button_3:setTitle(i18n("exitic_pavillion_text_0028"))
end
function Activity_9001680_BattleResultPanel:endShow()
	print("=======Activity_9001680_BattleResultPanel:endShow")
	self.isWin = self.param and self.param.isWin
	self.cellX = self.param and self.param.x
	self.cellY = self.param and self.param.y
	self.objCfg = self.param and self.param.objCfg
	if self.isWin then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_WinOrLose:playWin()
		self:initRewards()
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_WinOrLose:playLose()
		self.fields.text_lose:setString(i18n("exitic_pavillion_text_0114"))
	end
end
function Activity_9001680_BattleResultPanel:closeSelf()
	SoraDPlaySound()
	self:close()
end
function Activity_9001680_BattleResultPanel:reStart()
	SoraDPlaySound()
	local dispatchPanel = uiManager:show("WorldDispatchArmyView")
	_ENV = nil
	;(nil).activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001680
	;(nil).dispatchCallback = handler(self, self.onDispatchCallback)
	dispatchPanel:initData(nil)
end
function Activity_9001680_BattleResultPanel:onDispatchCallback(dispatchData)
	activity_9001680_Ctrl:reqGoldMinerPick(self.objCfg.index, self.cellX, self.cellY, false, dispatchData.armyList, dispatchData.heroInfo, dispatchData.armsInfo, dispatchData.divineBeastInfo)
	self:close()
	return true
end
function Activity_9001680_BattleResultPanel:initRewards(...)
	self.fields.reward_title:setString(i18n("common_text_094"))
	if not self.proxy.param or not self.proxy.param.rewards then
		local _ENV, rewards = self.proxy.param.rewards, self.proxy.param.rewards
	end
	self.fields.List_rewards:setItemRenderer(function(index, obj)
		local data = rewards[index + 1]
		obj:initData(data.id, data.count)
	end)
	self.fields.List_rewards:setNumItems(#rewards)
end
return Activity_9001680_BattleResultPanel
