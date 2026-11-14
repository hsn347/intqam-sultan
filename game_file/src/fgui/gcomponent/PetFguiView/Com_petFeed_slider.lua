local baseComponent = require("fgui.base.baseComponent")
local Com_petFeed_slider = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://PetFguiView/Com_petFeed_slider", Com_petFeed_slider)
local gametop = gModuleMgr.getObject("gametop")
local petCtrl = gametop.playertop_:getModule("petCtrl")
local petltCtrl = include("petltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local petDesRead = include("petDesRead")
local itemDesRead = include("itemDesRead")
local publicRead = include("publicRead")
local guideCtrl = gametop.playertop_:getModule("guideCtrl")
function Com_petFeed_slider:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.btn_hide:addEventListener(fgui.UIEventType.Click, handler(self, self.hideClick))
	self.fields.scroll_items:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.slider:addEventListener(fgui.UIEventType.Changed, handler(self, self.onSliderChangeEnd))
	self.fields.Button_add:addClickListener(handler(self, self.onAddClick))
	self.fields.Button_del:addClickListener(handler(self, self.onDelClick))
	self.fields.input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
	self.fields.input:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmit))
	self.fields.btn_useItem:setTitle(i18n("common_text_2919"))
	self.fields.text_noitem:setString(i18n("common_text_3416"))
	self.fields.btn_useItem:addEventListener(fgui.UIEventType.Click, handler(self, self.onUse))
end
function Com_petFeed_slider:onShow()
end
function Com_petFeed_slider:initData(isClick, petData, parentView)
	if not isClick then
		return
	end
	self.petData = petData
	self.parentView = parentView
	self.selectIdx = self.selectIdx and self.selectIdx or 1
	self:setClickIdx(self.selectIdx)
end
function Com_petFeed_slider:hideClick()
	self.parentView:isFeedItemClick(false)
	_ENV = self.parentView
	self.parentView.msg = "MESSAGE_UI_PET_ISFEEDITEM_SHOW"
	self.parentView.data = false
	SoraDSendMessage(self.parentView)
end
function Com_petFeed_slider:onItemRenderer(index, obj)
	local item = self.tableItem[index + 1]
	obj:initData(item.id, item.count)
	obj:setCanSelected(true)
	obj:setSelected(self.selectIdx == index + 1)
	obj:setClickCallback(function()
		self:setClickIdx(index + 1)
	end)
end
function Com_petFeed_slider:setClickIdx(idx)
	self.selectIdx = idx
	local tableItem = backpackCtrl:getPetFeedExpItemList(petltCtrl.getPetUnlockInfo(self.petData.petid).debrisid)
	self.fields.btn_useItem:setEnabled(0 < #tableItem)
	self.fields.item_cur:setVisible(0 < #tableItem)
	self.fields.text_item_name:setVisible(0 < #tableItem)
	self.fields.text_noitem:setVisible(#tableItem == 0)
	self.tableItem = tableItem
	self.fields.scroll_items:setNumItems(#tableItem)
	if #tableItem == 0 then
		backpackCtrl = #tableItem
		;(#tableItem).maxValue = 1
		self:setSlider(#tableItem)
		return
	end
	local itemData = tableItem[idx]
	if itemData == nil then
		self.fields.scroll_items:scrollToView(0, false, false)
		self:setClickIdx(1)
		return
	end
	self.selItemInfo = itemData
	self.fields.item_cur:initData(itemData.id)
	self.fields.text_item_name:setString(publicRead.getName(itemData.id))
	local nextExp = petltCtrl.getPetMaxLvExpWithRankFromLv(self.petData.petid, self.petData.rank, self.petData.level) - self.petData.curLevelExp
	local realNeedExp = math.min(PET_FEED_TOOL_EXP_LIMIT - petCtrl.feedInfo.curToolFeedExp, nextExp)
	local maxValue = math.ceil(realNeedExp / backpackltCtrl:getPetFeedExp(itemData.id))
	if maxValue == 0 then
		maxValue = 1
	end
	maxValue = math.min(math.min(itemData.count, 99999), maxValue)
	backpackCtrl = maxValue
	maxValue.maxValue = maxValue
	self:setSlider(maxValue)
end
function Com_petFeed_slider:setSlider(sliderData)
	local minValue = sliderData.minValue or 1
	self.minValue = math.max(1, minValue)
	local maxValue = sliderData.maxValue or 1
	self.maxValue = math.max(1, maxValue)
	local curValue = sliderData.curValue or 1
	self.curValue = math.max(minValue, math.min(curValue, maxValue))
	self.fields.slider:setMin(self.minValue)
	self.fields.slider:setMax(self.maxValue)
	self.fields.slider:setValue(self.curValue)
	self.fields.input:setText(self.curValue)
	self:updateExpPreview()
	self:setSliderCallBack(handler(self, self.updateExpPreview))
end
function Com_petFeed_slider:getSliderCurValue()
	return self.fields.slider:getValue()
end
function Com_petFeed_slider:setSliderCallBack(handle)
	self.handleChangeBack = handle
end
function Com_petFeed_slider:onSliderChangeEnd(Context)
	self.curValue = self.fields.slider:getValue()
	if self.handleChangeBack then
		self.handleChangeBack(self.curValue)
	end
	self.fields.input:setText(self.curValue)
end
function Com_petFeed_slider:onAddClick()
	SoraDPlaySound()
	self.curValue = math.min(self.maxValue, self.curValue + 1)
	self.fields.slider:setValue(self.curValue)
	self.fields.input:setText(self.curValue)
	if self.handleChangeBack then
		self.handleChangeBack(self.curValue)
	end
end
function Com_petFeed_slider:onDelClick()
	SoraDPlaySound()
	self.curValue = math.max(self.minValue, self.curValue - 1)
	self.fields.slider:setValue(self.curValue)
	self.fields.input:setText(self.curValue)
	if self.handleChangeBack then
		self.handleChangeBack(self.curValue)
	end
end
function Com_petFeed_slider:onChanged(Context)
	print("onChanged=====", self.fields.input:getText())
end
function Com_petFeed_slider:onSubmit(Context)
	local inputValue = self.fields.input:getText()
	if tonumber(inputValue) then
		self.curValue = math.max(self.minValue, math.min(tonumber(inputValue), self.maxValue))
		self.fields.input:setText(self.curValue)
		self.fields.slider:setValue(self.curValue)
	elseif self.curValue then
		self.fields.input:setText(self.curValue)
		self.fields.slider:setValue(self.curValue)
	end
end
function Com_petFeed_slider:onUse()
	SoraDPlaySound()
	local id = self.selItemInfo.id
	local num = self.curValue
	local nextExp = petltCtrl.getPetMaxLvExpWithRankFromLv(self.petData.petid, self.petData.rank, self.petData.level) - self.petData.curLevelExp
	local dayLimitFeedExp = PET_FEED_TOOL_EXP_LIMIT - petCtrl.feedInfo.curToolFeedExp
	local realNeedExp = math.min(dayLimitFeedExp, nextExp)
	local curFeedExp = num * backpackltCtrl:getPetFeedExp(id)
	if realNeedExp < curFeedExp then
		local msg = i18n("pet_text_09")
		if nextExp > dayLimitFeedExp then
			msg = i18n("pet_text_51")
		end
		SoraDShowMsgBox(msg, i18n("common_text_054"), nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				if not self.__cname then
					return
				end
				_ENV = nil
				;(nil).id = id
				;(nil).count = num
				petCtrl:reqFeedPet(self.petData.petid, gPetFeedType.TOOL, nil)
			end
		end)
		return
	end
	_ENV = nil
	;(nil).id = id
	;(nil).count = num
	petCtrl:reqFeedPet(self.petData.petid, gPetFeedType.TOOL, nil)
end
function Com_petFeed_slider:updateExpPreview()
	if not self.selItemInfo then
		return
	end
	local id = self.selItemInfo.id
	local value = self.curValue
	local itemType = backpackltCtrl:getItemType(id)
	if (itemType == gItemType.PET_EXP or backpackltCtrl:canGetPetFeedExp(self.selItemInfo.id)) and self.petData then
		print("updateExpPreview----------------------------")
		local curLv, curPercent = petCtrl:addPetExp(self.petData, 0)
		local totalAddExp = value * backpackltCtrl:getPetFeedExp(self.selItemInfo.id)
		totalAddExp = math.min(PET_FEED_TOOL_EXP_LIMIT, totalAddExp)
		local nextLv, nextPercent, totalExp, lastNeedExp = petCtrl:addPetExp(self.petData, totalAddExp)
		self.previewLevel = nextLv
		self.previewExp = totalExp
		self.previewLevelExp = lastNeedExp
		print("self.previewLevel = ", self.previewLevel, ",percetn=", nextPercent, ", self.previewExp = ", self.previewExp, ", self.previewLevelExp = ", self.previewLevelExp)
		local deltaExp = totalAddExp
		print("deltaExp = ", deltaExp)
		deltaExp = SoraDFIsRA() and string.formatnumberthousands(deltaExp) .. "+" or "+" .. string.formatnumberthousands(deltaExp)
		print("deltaExp = ", deltaExp)
		backpackltCtrl = "deltaExp = "
		backpackltCtrl, ("deltaExp = ").msg = deltaExp, "MESSAGE_UI_PET_FEEDITEM_UPADTE"
		deltaExp.previewLevel = self.previewLevel
		deltaExp.previewExp = self.previewExp
		deltaExp.previewLevelExp = self.previewLevelExp
		deltaExp.oldPreviewLevel = self.petData.level
		;("deltaExp = ").data, deltaExp.deltaExp = deltaExp, deltaExp
		SoraDSendMessage("deltaExp = ")
	end
end
return Com_petFeed_slider
