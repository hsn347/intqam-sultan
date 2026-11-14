local publicRead = include("publicRead")
local constantRead = include("constantRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ItemSendPopPanel = class("ItemSendPopPanel", baseFguiPanel)
function ItemSendPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ItemSendPopPanel:ctor", self.viewName)
end
function ItemSendPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ItemSendPopPanel:onInit()
	print("=======ItemSendPopPanel:onInit")
	local maxVal = 0
	if self.param.maxValue then
		maxVal = self.param.maxValue
	else
		maxVal = math.min(backpackCtrl:getItemCount(self.param.itemID), constantRead.getConstValue("UPPER_LIMIT_OF_DONATION"))
	end
	_ENV = constantRead.getConstValue("UPPER_LIMIT_OF_DONATION")
	constantRead.getConstValue("UPPER_LIMIT_OF_DONATION").maxValue = maxVal
	constantRead.getConstValue("UPPER_LIMIT_OF_DONATION").minValue = 1
	constantRead.getConstValue("UPPER_LIMIT_OF_DONATION").curValue = 1
	self.fields.Com_slider:initData(constantRead.getConstValue("UPPER_LIMIT_OF_DONATION"))
	self.fields.Btn_send:setString(i18n("common_text_3644"))
	self.fields.Btn_send:addClickListener(handler(self, self.onSendClick))
	self.fields.Text_select:setString(i18n("common_text_4836"))
	self.fields.list_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Com_item:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Com_slider:setInpuBoxFixPos()
end
function ItemSendPopPanel:onShow()
	print("=======ItemSendPopPanel:onShow")
	local itemID = self.param.itemID
	self.itemID = itemID
	self.fields.Text_name:setString(i18n(publicRead.getName(itemID)))
	self.fields.Panel_bg:setString(i18n(publicRead.getName(itemID)))
	self.fields.Com_item:initData(itemID, backpackCtrl:getItemCount(itemID))
	local result = backpackltCtrl:getResult(itemID)
	_UPVALUE4_ = backpackCtrl:getItemCount(itemID)
	backpackCtrl:getItemCount(itemID)[1] = "id"
	backpackCtrl:getItemCount(itemID)[2] = "num"
	backpackCtrl:getItemCount(itemID)[3] = "limitType"
	backpackCtrl:getItemCount(itemID)[4] = "limitNum"
	self.results = serviceFunctions.tableFormat(result, backpackCtrl:getItemCount(itemID))
	for i, v in ipairs(self.results) do
		self:setLockData(v)
	end
	self.controllers.c1:setSelectedIndex(#self.results > 0 and 0 or 1)
	self:onCurItemSelected(1)
end
function ItemSendPopPanel:setLockData(result)
	local tipStr = ""
	local isLock = false
	local limitType = result.limitType
	local limitNum = result.limitNum
	if limitType == 1 then
		_ENV = nil
		;(nil).lv = limitNum
		tipStr = i18n("common_text_4837", nil)
		isLock = limitNum > SoraDGetLordLv()
	elseif limitType == 2 then
		_ENV = nil
		;(nil).lv = limitNum
		tipStr = i18n("common_text_4838", nil)
		isLock = limitNum > SoraDGetCastleLv()
	elseif limitType == 3 then
		_ENV = nil
		;(nil).lv = limitNum
		tipStr = i18n("common_text_4839", nil)
		isLock = limitNum > SoraDGetBuildStarLv()
	elseif limitType == 4 then
		_ENV = nil
		;(nil).lv = limitNum
		tipStr = i18n("common_text_4840", nil)
		local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
		isLock = limitNum > magicLampCtrl:getJinnLv(gJinnType.JINN_ONE)
	elseif limitType == 5 then
		_ENV = magicLampCtrl
		magicLampCtrl.lv = limitNum
		tipStr = i18n("common_text_4841", magicLampCtrl)
		local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
		isLock = limitNum > magicLampCtrl:getJinnLv(gJinnType.JINN_TWO)
	end
	result.tipStr = tipStr
	result.isLock = isLock
end
function ItemSendPopPanel:onCurItemSelected(index)
	self.curSelectedIndex = index
	local v = self.results[index]
	local isLock = v.isLock
	local resultID = v.id
	local resultNum = v.num
	_ENV = nil
	;(nil).item1 = i18n(publicRead.getName(self.itemID))
	;(nil).item2 = i18n(publicRead.getName(resultID))
	;(nil).name = self.param.data.nickName
	;(nil).num = resultNum
	self.fields.Text_des:setString(i18n("common_text_4687", nil))
	self.fields.Btn_send:setGrayed(isLock)
	self.fields.text_tips:setVisible(isLock)
	if isLock then
		self.fields.text_tips:setString(v.tipStr)
	end
	self.fields.list_item:setNumItems(#self.results)
	self.fields.list_item:scrollToView(self.curSelectedIndex - 1)
end
function ItemSendPopPanel:onSendClick()
	SoraDPlaySound()
	local itemID = self.param.itemID
	local useCount = self.fields.Com_slider:getSliderCurValue()
	local result = self.results[self.curSelectedIndex]
	if result.isLock then
		SoraDShowMsgTip(result.tipStr)
		return
	else
		_ENV = nil
		;(nil).uid = self.param.data.uid
		;(nil).itemId = result.id
		backpackCtrl:reqUseItem(itemID, useCount, nil)
	end
	self:close()
end
function ItemSendPopPanel:onItemRenderer(index, obj)
	obj:initData(self.results[index + 1], index + 1, self.curSelectedIndex)
	obj:setClickCallback(handler(self, self.onCurItemSelected))
end
return ItemSendPopPanel
