local publicRead = include("publicRead")
local monsterpalaceltCtrl = gModuleMgr.sharedMgr("monsterpalaceltCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local monsterpalaceCtrl = SoraDGetCtrl("monsterpalaceCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local evilPalaceInfoViewPanel = class("evilPalaceInfoViewPanel", baseFguiPanel)
function evilPalaceInfoViewPanel:ctor(...)
	evilPalaceInfoViewPanel.super.ctor(self, ...)
	print("evilPalaceInfoViewPanel:ctor", self.viewName)
end
function evilPalaceInfoViewPanel:onInit()
	print("=======evilPalaceInfoViewPanel:onInit")
	self.itemList, _ENV = print, print
	self.fields.Text_dropTip:setString(i18n("common_text_488"))
	self.fields.Text_monterTalk:setAlign(2)
	self.fields.Text_monterTalk:setString(i18n("common_text_3285"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.Text_addition = SoraDCreateTimerLabel(self, self.fields.Text_addition)
	if SoraDFIsRA() then
		self.Text_addition:setTimeLast(function(ticket)
			return string.format("%s    %s", i18n("magic_underground_text_01"), ticket)
		end)
	else
		self.Text_addition:setTimeLast(function(ticket)
			return string.format("%s    %s", ticket, i18n("magic_underground_text_01"))
		end)
	end
	self.Text_addition:setVisible(false)
end
function evilPalaceInfoViewPanel:onItemRenderer(index, obj)
	obj:getChildByName("item"):initData(self.itemList[index + 1].id, self.itemList[index + 1].num)
	obj:getChildByName("title"):setString(publicRead.getName(self.itemList[index + 1].id))
end
function evilPalaceInfoViewPanel:onShow()
	print("=======angerDetailViewPanel:onShow")
	self.battleType = self.param and self.param.battleType or gMonsterpalaceBattletype.NORMAL_BATTLE
	self:initView()
end
function evilPalaceInfoViewPanel:initView()
