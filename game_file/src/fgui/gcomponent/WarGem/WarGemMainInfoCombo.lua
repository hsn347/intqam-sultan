local combinationCtrl = SoraDGetCtrl("combinationCtrl")
local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local warGemltCtrl = include("warGemltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local WarGemMainInfoCombo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarGem/WarGemMainInfoCombo", WarGemMainInfoCombo)
function WarGemMainInfoCombo:onInit()
	self.ctype = combinationCtrl.COMBINATION_TYPE.WARGEM
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function WarGemMainInfoCombo:onClickItem()
	SoraDPlaySound()
	local index = self.fields.List:getSelectedIndex()
	local setID = index + 1
	if setID < 1 then
		error("setID < 1")
		return
	end
	if not combinationCtrl:checkSetUnLock(self.ctype, setID, true) then
		self.fields.List:setSelectedIndex(self.defaultIndex)
		return
	end
	if self.callback then
		self.callback(self.fields.List:getSelectedIndex() + 1)
	end
	self:setVisible(false)
end
function WarGemMainInfoCombo:onItemRenderer(index, obj)
	local panelIndex = index + 1
	obj:initData(self.ctype, panelIndex, panelIndex == warGemCtrl:getActPanelId())
end
function WarGemMainInfoCombo:onShow()
end
function WarGemMainInfoCombo:setCallback(callback)
	self.callback = callback
end
function WarGemMainInfoCombo:initData()
	self.fields.List:setNumItems(warGemltCtrl:getGemSwitchCount())
	local selectIndex = warGemCtrl:getEditPanelId() - 1
	self.defaultIndex = selectIndex
	self.fields.List:setSelectedIndex(selectIndex)
end
return WarGemMainInfoCombo
