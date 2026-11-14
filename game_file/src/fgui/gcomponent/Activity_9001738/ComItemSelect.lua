local baseComponent = require("fgui.base.baseComponent")
local ComItemSelect = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001738/ComItemSelect", ComItemSelect)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
function ComItemSelect:onInit()
	self:setChangeStateOnClick(false)
	self.fields.com_item:setTouchable(true)
	self.fields.com_item:setClickCallback(handler(self, self.onClickItem))
end
function ComItemSelect:onShow()
end
function ComItemSelect:setItemSelected(isSelected)
	self.isSelected = isSelected == true
	self:setSelected(self.isSelected)
	self.controllers.button:setSelectedIndex(self.isSelected and 1 or 0)
end
function ComItemSelect:initData(data, isSelected, selectCallback, index)
	self.data = data
	self.isRewardPreview = type(data) ~= "table"
	self.itemID = self.isRewardPreview and data or data.itemID or data.id or 0
	self.selectCallback = selectCallback
	self.index = index
	self.count = isSelected or 0 or backpackCtrl:getItemCount(self.itemID) or 0
	self.isSelected = not self.isRewardPreview and 0 < self.count and isSelected == true
	self.fields.com_item:initData(self.itemID, self.count, nil, not self.isRewardPreview and 0 >= self.count and "#BE2828" or nil)
	if 0 >= self.count then
		self.fields.com_item:setNumText(fguiHelper.getColorString("#BE2828", "0"))
	end
	self:setItemSelected(self.isSelected)
end
function ComItemSelect:onClickItem()
	if self.isRewardPreview then
		return
	end
	SoraDPlaySound()
	if self.count <= 0 then
		self:setItemSelected(false)
		if self.selectCallback then
			self.selectCallback(self.itemID, false, self.index)
		end
		SoraDShowMsgTip(i18n("memory_flip_text_06"))
		return
	end
	self:setItemSelected(not self.isSelected)
	if self.selectCallback then
		self.selectCallback(self.itemID, self.isSelected, self.index)
	end
end
return ComItemSelect
