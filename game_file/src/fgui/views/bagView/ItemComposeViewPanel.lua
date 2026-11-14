local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ItemComposeViewPanel = class("ItemComposeViewPanel", baseFguiPanel)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local publicRead = include("publicRead")
function ItemComposeViewPanel:ctor(...)
	ItemComposeViewPanel.super.ctor(self, ...)
	print("ItemComposeViewPanel:ctor", self.viewName)
end
function ItemComposeViewPanel:onInit()
	print("=======ItemComposeViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_1352"))
	self.fields.button_sure:setTitleText(i18n("common_text_1352"))
	self.fields.button_sure:addClickListener(handler(self, self.onClickConfim))
	self.fields.item_source:fixPos()
	self.fields.item_target:fixPos()
	self.fields.Com_Slider:setSliderCallBack(handler(self, self.sliderCallBack))
end
function ItemComposeViewPanel:onShow()
	print("=======ItemComposeViewPanel:onShow")
	self:initData()
end
function ItemComposeViewPanel:initData()
	local itemID = self.proxy.param.itemID
	self.itemID = itemID
	dump(itemID, "ItemComposeViewPanel:initData")
	self.SyntheticsParameter = backpackltCtrl:getSyntheticsParameter(itemID)
	self.sourceItemName = publicRead.getName(itemID)
	self.targetItemName = publicRead.getName(self.SyntheticsParameter[2])
	self.itemNum = backpackCtrl:getItemCount(self.itemID)
	self.maxNum = math.floor(backpackCtrl:getItemCount(self.itemID) / self.SyntheticsParameter[1])
	local useMax = 9999
	if self.maxNum >= 999 then
		if useMax == 9999 then
			self.maxNum = self.maxNum >= 9999 and 9999 or self.maxNum
		else
			self.maxNum = 999
		end
	end
	self.maxNum = math.min(self.maxNum, useMax)
	_ENV = useMax
	useMax.maxValue = self.maxNum
	useMax.minValue = 1
	useMax.curValue = 1
	self.fields.Com_Slider:initData(useMax)
	self.curCount = math.min(self.maxNum, curCount or 1)
	self.fields.Com_Slider:setInpuBoxFixPos(45, 130, 190)
	if self.curCount <= 0 then
		self.fields.button_sure:setTitleColor(cc.c3b(255, 0, 0))
	else
		self.fields.button_sure:setTitleColor(cc.c3b(255, 255, 255))
	end
end
function ItemComposeViewPanel:sliderCallBack(value)
	if 0 < value then
		self.curCount = value
		self.curCost = value * self.SyntheticsParameter[1]
		_ENV = nil
		;(nil).num1 = self.curCost
		;(nil).name1 = self.sourceItemName
		;(nil).num2 = value
		;(nil).name2 = self.targetItemName
		dump(nil, "ItemComposeViewPanel:sliderCallBack")
		_ENV = nil
		;(nil).num1 = self.curCost
		;(nil).name1 = self.sourceItemName
		;(nil).num2 = value
		;(nil).name2 = self.targetItemName
		self.fields.txt_tip:setString(i18n("Itemsynthetics2", nil))
		self.fields.item_source:initData(self.itemID, self.curCost)
		self.fields.item_target:initData(self.SyntheticsParameter[2], self.curCount)
	end
end
function ItemComposeViewPanel:onClickConfim()
	SoraDPlaySound()
	_UPVALUE2_ = nil
	;(nil)[1] = self.itemNum
	;(nil)[2] = self.curCount
	dump(nil, "self.curCount")
	if self.curCount > 0 and self.itemNum >= self.curCount * self.SyntheticsParameter[1] then
		backpackCtrl:translateItem(self.itemID, self.curCount)
		self:close()
	else
		SoraDShowMsgTip(i18n("Snowman_text_10"))
	end
end
return ItemComposeViewPanel
