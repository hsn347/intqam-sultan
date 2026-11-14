local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001680_ItemGetPanel = class("Activity_9001680_ItemGetPanel", baseFguiPanel)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
local constantRead = include("constantRead")
local activity_9001680_Read = include("activity_9001680_Read")
function Activity_9001680_ItemGetPanel:ctor(...)
	self.isLRU = true
	Activity_9001680_ItemGetPanel.super.ctor(self, ...)
	print("Activity_9001680_ItemGetPanel:ctor", self.viewName)
end
function Activity_9001680_ItemGetPanel:onInit()
	self.view:fixChildrenPos()
	print("=======Activity_9001680_ItemGetPanel:onInit")
	self.itemID = 1698
	self.useItemID = constantRead.getConstValue("GLODMINER_PICK_PACK_ITEMID")
	self.freeItemID = constantRead.getConstValue("GLODMINER_PICK_PACK_FREE_ITEMID")
	self.itemTime = constantRead.getConstValue("GLODMINER_PICK_GET_TIME")
	self.fields.Button_use:setTitle(i18n("common_text_314"))
	self.fields.Button_use:addClickEventListener(handler(self, self.onUseClick))
	self.fields.Button_use2:setTitle(i18n("common_text_314"))
	self.fields.Button_use2:addClickEventListener(handler(self, self.onFreeClick))
	self.fields.Panel_bg:setTitle(i18n("minecraft_text_12"))
	_ENV = i18n("minecraft_text_12")
	i18n("minecraft_text_12").time = self.itemTime / 60
	self.fields.text_1:setString(i18n("minecraft_text_13", i18n("minecraft_text_12")))
	self.textTime = SoraDCreateTimerLabel(self, self.fields.text_2)
	self.textTime:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("minecraft_text_14", nil)
	end)
	self.rechargeCfg = activity_9001680_Read.getRechargeCfg(1)
end
function Activity_9001680_ItemGetPanel:endShow()
	print("=======Activity_9001680_ItemGetPanel:endShow")
	self:updateView()
end
function Activity_9001680_ItemGetPanel:updateView()
	local itemNum, itemMax = activity_9001680_Ctrl:getItemCount()
	self.fields.Bar_1:setMax(itemMax)
	self.fields.Bar_1:setValue(itemNum)
	self.fields.Bar_1:setBarTitle(string.format("%d/%d", itemNum, itemMax))
	self.useItemNum = backpackCtrl:getItemCount(self.useItemID)
	self.fields.Com_item:initData(self.useItemID, self.useItemNum)
	self.fields.text_name:setString(publicRead.getName(self.useItemID))
	self.fields.text_desc:setString(publicRead.getDes(self.useItemID))
	self.fields.Button_use:setGrayed(self.useItemNum <= 0)
	self.freeItemNum = backpackCtrl:getItemCount(self.freeItemID)
	self.fields.Com_item2:initData(self.freeItemID, self.freeItemNum)
	self.fields.text_name2:setString(publicRead.getName(self.freeItemID))
	self.fields.text_desc2:setString(publicRead.getDes(self.freeItemID))
	self.fields.Button_use2:setGrayed(0 >= self.freeItemNum)
	if itemNum < itemMax then
		local countTime = (itemMax - itemNum - 1) * self.itemTime + self.itemTime - (serviceFunctions.systemTime() - activity_9001680_Ctrl:getPickaxeTime())
		self.textTime:beginTime(countTime)
	else
		self.textTime:endTime()
		self.textTime:setString(i18n("minecraft_text_42"))
	end
	self.fields.Com_9001680_Gift:initData(self.rechargeCfg)
end
function Activity_9001680_ItemGetPanel:onUseClick()
	SoraDPlaySound()
	if self.useItemNum <= 0 then
		_ENV = nil
		;(nil).name = publicRead.getName(self.useItemID)
		SoraDShowMsgTip(i18n("commom_text_4302", nil))
		return
	end
	backpackCtrl:reqUseItem(self.useItemID, 1)
end
function Activity_9001680_ItemGetPanel:onFreeClick()
	SoraDPlaySound()
	if self.freeItemNum <= 0 then
		_ENV = nil
		;(nil).name = publicRead.getName(self.freeItemID)
		SoraDShowMsgTip(i18n("commom_text_4302", nil))
		return
	end
	backpackCtrl:reqUseItem(self.freeItemID, 1)
end
return Activity_9001680_ItemGetPanel
