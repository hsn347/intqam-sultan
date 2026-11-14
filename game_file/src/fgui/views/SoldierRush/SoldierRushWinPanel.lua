local soldierRushRead = include("soldierRushRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SoldierRushWinPanel = class("SoldierRushWinPanel", baseFguiPanel)
function SoldierRushWinPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SoldierRushWinPanel:ctor", self.viewName)
end
function SoldierRushWinPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SoldierRushWinPanel:onInit()
	print("=======SoldierRushWinPanel:onInit")
	self.reward = self.param.reward
	self.id = self.param.id
	self.fields.Text_tip:setString(i18n("soldier_rush_text_29"))
	self.fields.List_target:setItemRenderer(handler(self, self.onTargetRenderer))
	self.fields.List_award:setItemRenderer(handler(self, self.onRewardRenderer))
	SoraDPlaySound("uicontrol", 53)
end
function SoldierRushWinPanel:onTargetRenderer(index, obj)
	obj:initData(self.conditionList[index + 1], self.id)
end
function SoldierRushWinPanel:onRewardRenderer(index, obj)
	local data = self.reward[index + 1]
	obj:initData(data.id, data.count)
end
function SoldierRushWinPanel:onShow()
	print("=======SoldierRushWinPanel:onShow")
	SoraDPlaySound("elimiateGame", 5)
	if display.height > 1136 then
		self.fields.Usm_1:setScale(display.height / 1136)
		self.fields.Usm_2:setScale(display.height / 1136)
		self.fields.Usm_3:setScale(display.height / 1136)
	end
	self.fields.Usm_1:setEffectPath("dunpai2.usm", false)
	self.fields.Usm_2:setEffectPath(SoraDFIsRA() and "dunpai5.usm" or "dunpai4.usm", false)
	self.fields.Usm_2:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_3:setEffectPath("G_dunpai1.usm,G_xh_dunpai3.usm")
	self.fields.Usm_3:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
	self.conditionList = soldierRushRead.getLevelStarCfg(self.id)
	self.fields.List_target:setNumItems(#self.conditionList)
	if self.reward then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.List_award:setNumItems(#self.reward)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
function SoldierRushWinPanel:close()
	print("=======SoldierRushWinPanel:close")
	_ENV = "=======SoldierRushWinPanel:close"
	;("=======SoldierRushWinPanel:close").msg = "MESSAGE_SOLDIERRUSH_UI_END_GAME"
	SoraDSendMessage("=======SoldierRushWinPanel:close")
	local levelID = self.id
	self:closePanel()
	_ENV = self
	self.msg = "MESSAGE_SOLDIERRUSH_UI_GUIDE_NEXT"
	self.levelID = levelID
	SoraDSendMessage(self)
end
return SoldierRushWinPanel
