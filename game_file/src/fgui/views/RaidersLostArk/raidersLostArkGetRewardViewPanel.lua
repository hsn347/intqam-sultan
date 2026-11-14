local baseFguiPanel = require("fgui.base.baseFguiPanel")
local raidersLostArkGetRewardViewPanel = class("raidersLostArkGetRewardViewPanel", baseFguiPanel)
function raidersLostArkGetRewardViewPanel:ctor(...)
	self.isLRU = true
	raidersLostArkGetRewardViewPanel.super.ctor(self, ...)
	print("raidersLostArkGetRewardViewPanel:ctor", self.viewName)
end
function raidersLostArkGetRewardViewPanel:onInit()
	print("=======raidersLostArkGetRewardViewPanel:onInit")
	self.fields.Text_title:setString(i18n("Martial_arts_text_09"))
	self.fields.Button_Sure:setString(i18n("common_text_204"))
	self.fields.Button_Sure:addClickListener(handler(self, self.btnSureClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function raidersLostArkGetRewardViewPanel:onItemRenderer(index, obj)
	obj:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
function raidersLostArkGetRewardViewPanel:endShow()
	print("=======raidersLostArkGetRewardViewPanel:endShow")
	self.controllers.c1:setSelectedIndex(SoraDFIsRA() and 0 or 1)
	self.rewardList = self.param.rewardList
	self.fields.List:setNumItems(#self.rewardList)
end
function raidersLostArkGetRewardViewPanel:btnSureClick()
	SoraDPlaySound()
	self:close()
end
return raidersLostArkGetRewardViewPanel
