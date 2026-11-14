local activity_9001678_Ctrl = SoraDGetCtrl("activity_9001678_Ctrl")
local activity_9001678_Read = include("activity_9001678_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001714_MainPanel = class("Activity_9001714_MainPanel", baseFguiPanel)
function Activity_9001714_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001714_MainPanel.super.ctor(self, ...)
	print("Activity_9001714_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FROSTY_MARKET
end
function Activity_9001714_MainPanel:onInit()
	print("=======Activity_9001714_MainPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.frostyID = activity_9001678_Read.getFrostyMarketToolID()
	self.fields.Com_title:initData(i18n("activity_name_9001714"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Text_tip:setString(i18n("Frosty_Market_text_02"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Activity_9001714_MainPanel:onItemRenderer(index, obj)
	obj:initData(self.marketList[index + 1])
end
function Activity_9001714_MainPanel:endShow()
	print("=======Activity_9001714_MainPanel:endShow")
	self:initView()
end
function Activity_9001714_MainPanel:initView()
	self.fields.Com_have:initData(self.frostyID, handler(self, self.openGift))
	self.marketList = activity_9001678_Ctrl:getDayGoodsList()
	self.fields.List:setNumItems(#self.marketList)
end
function Activity_9001714_MainPanel:openGift()
	SoraDPlaySound()
	uiManager:show("Activity_9001714_Gift")
end
function Activity_9001714_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Frosty_Market_text_01")
	uiManager:show("RuleView", nil)
end
return Activity_9001714_MainPanel
