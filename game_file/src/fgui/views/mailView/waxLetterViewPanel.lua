local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local timeLimitedItemCtrl = SoraDGetCtrl("timeLimitedItemCtrl")
local MAX_NUM = IsArClient and 99 or 10
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local waxLetterViewPanel = class("waxLetterViewPanel", baseFguiPanel)
function waxLetterViewPanel:ctor(...)
	waxLetterViewPanel.super.ctor(self, ...)
	print("waxLetterViewPanel:ctor", self.viewName)
end
function waxLetterViewPanel:onInit()
	print("=======waxLetterViewPanel:onInit")
	self.itemList, _ENV = print, print
	self.selectID = nil
	self.fields.Panel_bg:setString(i18n("Smelt_text_02"))
	self.fields.Text_notice:setString(i18n("common_text_2802"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_none:setString(i18n("common_text_4835"))
	self.fields.Text_none:setVisible(false)
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnClick))
	self.fields.Button_ok:setEnabled(false)
end
function waxLetterViewPanel:onShow()
	print("=======waxLetterViewPanel:onShow")
	self.index = self.param.index or 1
	self.totalCount = self.param.totalCount or 0
	if not self.param.itemNumInfo then
		_ENV = self.param.itemNumInfo
	end
	self.itemNumInfo = self.param.itemNumInfo
	self.itemID = self.param.itemID or 501901
	self.selInfo = self.param.selInfo
	if self.itemID == 501901 then
		self.maxCost = MAX_NUM
	else
		self.maxCost = backpackltCtrl:getUseMax(self.itemID)
	end
	self:initData()
end
function waxLetterViewPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1].id, self.itemList[index + 1].count)
	obj:setSelectShow(true)
	obj:setSelected(self.selInfo and self.selInfo.id == self.itemList[index + 1].id)
end
function waxLetterViewPanel:itemChoose(target, data)
	if self.selectID and self.selectID == data.id then
		return
	end
	self.selectID = data.id
	local itemNum = backpackCtrl:getItemCount(self.selectID)
	for i, v in ipairs(self.itemList) do
		if v.id == self.selectID then
			itemNum = v.count
		end
	end
	local maxValue = math.min(self.maxCost, itemNum)
	backpackCtrl = nil
	;(nil).maxValue = maxValue
	;(nil).minValue = 1
	;(nil).curValue = data.value or 1
	;(nil).allowZero = true
	self.fields.Com_slider:initData(nil)
	self.fields.Button_ok:setEnabled(true)
end
function waxLetterViewPanel:initData()
	self.itemList, backpackCtrl = nil, nil
	self.itemNum = backpackCtrl:getItemCount(self.itemID)
	self.maxCost = math.min(self.maxCost - self.totalCount, self.itemNum - self.totalCount)
	backpackCtrl = self.itemNum - self.totalCount
	;(self.itemNum - self.totalCount).maxValue = self.maxCost
	;(self.itemNum - self.totalCount).minValue = 1
	;(self.itemNum - self.totalCount).curValue = 1
	;(self.itemNum - self.totalCount).allowZero = true
	self.fields.Com_slider:initData(self.itemNum - self.totalCount)
	local backpack = backpackCtrl:getBackpack(gBackpackDef.PROPS)
	local itemsData = backpack:getList()
	for i, v in ipairs(itemsData) do
		if backpackltCtrl:canGive(v.id) then
			local count = v.count - (self.itemNumInfo[v.id] or 0)
			if 0 < count then
				backpackCtrl = nil
				;(nil).id = v.id
				;(nil).count = count
				table.insert(self.itemList, nil)
			end
		end
	end
	if self.selInfo and self.selInfo.id then
		backpackCtrl = nil
		;(nil).id = self.selInfo.id
		;(nil).value = self.selInfo.count or 0
		self:itemChoose(self, nil)
	end
	self.fields.List:setNumItems(#self.itemList)
	self.fields.Text_none:setVisible(#self.itemList == 0)
end
function waxLetterViewPanel:btnClick()
	SoraDPlaySound()
	local selectNum = self.fields.Com_slider:getSliderCurValue()
	if 0 < selectNum then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAIL_UI_GIVE_PRESENT_ITEM_SELECTED"
		;(nil).index = self.index
		;(nil).itemID = self.selectID
		;(nil).count = selectNum
		SoraDSendMessage(nil)
	else
		SoraDShowMsgTip(i18n("Pigeon_use_on_line"))
	end
	self:close()
end
return waxLetterViewPanel
