local publicRead = include("publicRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activity_9001660_Ctrl = SoraDGetCtrl("activity_9001660_Ctrl")
local activity_9001660_Read = include("activity_9001660_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001660_DetailViewPanel = class("Activity_9001660_DetailViewPanel", baseFguiPanel)
function Activity_9001660_DetailViewPanel:ctor(...)
	Activity_9001660_DetailViewPanel.super.ctor(self, ...)
	print("Activity_9001660_DetailViewPanel:ctor", self.viewName)
end
function Activity_9001660_DetailViewPanel:onInit()
	print("=======Activity_9001660_DetailViewPanel:onInit")
	self.itemList, _ENV = print, print
	self.fields.Text_dropTip:setString(i18n("common_text_488"))
	self.fields.Text_monterTalk:setAlign(2)
	self.fields.Text_monterTalk:setString(i18n("mutated_tentacles_text3"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001660_DetailViewPanel:onItemRenderer(index, obj)
	obj:getChildByName("item"):initData(self.itemList[index + 1].id, self.itemList[index + 1].num)
	obj:getChildByName("title"):setString(publicRead.getName(self.itemList[index + 1].id))
end
function Activity_9001660_DetailViewPanel:onShow()
	print("=======Activity_9001660_DetailViewPanel:onShow")
	self.battleType = self.param and self.param.battleType or activity_9001660_Read.gMutantTentaclesBattletype.NORMAL_BATTLE
	self:initView()
end
function Activity_9001660_DetailViewPanel:initView()
