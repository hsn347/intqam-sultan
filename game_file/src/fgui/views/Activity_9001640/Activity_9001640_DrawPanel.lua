local activityCommonDrawCtrl = SoraDGetCtrl("activityCommonDrawCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001640_DrawPanel = class("Activity_9001640_DrawPanel", baseFguiPanel)
function Activity_9001640_DrawPanel:ctor(...)
	Activity_9001640_DrawPanel.super.ctor(self, ...)
	print("Activity_9001640_DrawPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.PHOENIX_ARRIVAL
	self.itemID = activityCommonDrawCtrl:getItemID(self.activityID)
	self.itemCost = activityCommonDrawCtrl:getItemCost(self.activityID)
	self:_addPackage("CommonDispatch")
end
function Activity_9001640_DrawPanel:onInit()
	print("=======Activity_9001640_DrawPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Eidal_feast_text_06"))
	self.fields.Button_draw:setString(i18n("Eidal_feast_text_06"))
	self.fields.Button_draw:addClickListener(handler(self, self.onClickBtnDraw))
	self.fields.Button_draw:setCost(self.itemID, 0)
end
function Activity_9001640_DrawPanel:onShow()
	print("=======Activity_9001640_DrawPanel:onShow")
	local itemCount = self.param and self.param.itemCount or backpackCtrl:getItemCount(self.itemID)
	local maxValue = math.floor(itemCount / self.itemCost)
	self.fields.Com_slide:setSliderCallBack(function(curValue)
		self.fields.Button_draw:setCostNum(curValue * self.itemCost)
	end)
	function _ENV(curValue)
		self.fields.Button_draw:setCostNum(curValue * self.itemCost)
	end
	;(function(curValue)
		self.fields.Button_draw:setCostNum(curValue * self.itemCost)
	end).maxValue = maxValue
	self.fields.Com_slide:initData(function(curValue)
		self.fields.Button_draw:setCostNum(curValue * self.itemCost)
	end)
end
function Activity_9001640_DrawPanel:onClickBtnDraw(...)
	SoraDPlaySound()
	local curValue = self.fields.Com_slide:getSliderCurValue()
	activityCommonDrawCtrl:reqDrawOne(self.activityID, curValue)
	self:closePanel()
end
return Activity_9001640_DrawPanel
