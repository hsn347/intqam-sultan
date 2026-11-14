local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001676_ItemGetPanel = class("Activity_9001676_ItemGetPanel", baseFguiPanel)
local publicRead = include("publicRead")
local activity_9001676_Ctrl = SoraDGetCtrl("activity_9001676_Ctrl")
local activity_9001676_Read = include("activity_9001676_Read")
local constantRead = include("constantRead")
function Activity_9001676_ItemGetPanel:ctor(...)
	self.isLRU = true
	Activity_9001676_ItemGetPanel.super.ctor(self, ...)
	print("Activity_9001676_ItemGetPanel:ctor", self.viewName)
end
function Activity_9001676_ItemGetPanel:onInit()
	print("=======Activity_9001676_ItemGetPanel:onInit")
	self.itemData = constantRead.getConstValueArray("KOREAN_CHESS_FREE_REWARD")
	self.fields.Button_use:setTitle(i18n("krone_text_51"))
	self.fields.Button_use:addClickEventListener(handler(self, self.onUseClick))
	self.fields.Panel_bg:setTitle(i18n("krone_text_42"))
	self.rechargeCfg = activity_9001676_Read.getRechargeCfg(1)
	self.view:fixChildrenPos()
end
function Activity_9001676_ItemGetPanel:endShow()
	print("=======Activity_9001676_ItemGetPanel:endShow")
	self:updateView()
end
function Activity_9001676_ItemGetPanel:updateView()
	self.fields.Com_item:initData(self.itemData[1], self.itemData[2])
	self.fields.text_name:setString(publicRead.getName(self.itemData[1]))
	self.fields.text_desc:setString(publicRead.getDes(self.itemData[1]))
	self.isGetFreeReward = activity_9001676_Ctrl:getIsGetFreeReward()
	self.fields.Button_use:setEnabled(not self.isGetFreeReward)
	self.fields.Com_9001676_Gift:initData(self.rechargeCfg)
end
function Activity_9001676_ItemGetPanel:onUseClick()
	SoraDPlaySound()
	if not self.isGetFreeReward then
		activity_9001676_Ctrl:reqKoreanChessFreeGift()
	end
end
return Activity_9001676_ItemGetPanel
