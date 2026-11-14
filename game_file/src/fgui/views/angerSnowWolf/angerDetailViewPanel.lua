local publicRead = include("publicRead")
local snowWolfltCtrl = gModuleMgr.sharedMgr("snowWolfltCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local angrySnowWolfKingCtrl = SoraDGetCtrl("angrySnowWolfKingCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local angerDetailViewPanel = class("angerDetailViewPanel", baseFguiPanel)
function angerDetailViewPanel:ctor(...)
	angerDetailViewPanel.super.ctor(self, ...)
	print("angerDetailViewPanel:ctor", self.viewName)
end
function angerDetailViewPanel:onInit()
	print("=======angerDetailViewPanel:onInit")
	self.itemList, _ENV = print, print
	self.fields.Text_dropTip:setString(i18n("common_text_488"))
	self.fields.Text_monterTalk:setAlign(2)
	self.fields.Text_monterTalk:setString(i18n("Challenge_SnowWolf_text_05"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function angerDetailViewPanel:onItemRenderer(index, obj)
	obj:getChildByName("item"):initData(self.itemList[index + 1].id, self.itemList[index + 1].num)
	obj:getChildByName("title"):setString(publicRead.getName(self.itemList[index + 1].id))
end
function angerDetailViewPanel:onShow()
	print("=======angerDetailViewPanel:onShow")
	self.battleType = self.param and self.param.battleType or gAngrySnowWolfKingBattletype.NORMAL_BATTLE
	self:initView()
end
function angerDetailViewPanel:initView()
