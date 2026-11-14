local baseComponent = require("fgui.base.baseComponent")
local BtnConsumable = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001738/BtnConsumable", BtnConsumable)
local publicRead = include("publicRead")
function BtnConsumable:onInit()
	self:addClickListener(handler(self, self.onClickItem))
	self.fields.n3:setVisible(false)
	self.fields.txtNum:setVisible(false)
end
function BtnConsumable:onShow()
end
function BtnConsumable:initData(data, isSelected, isEnabled, clickCallback)
	self.data = data
	self.itemID = data.itemID or 0
	self.isSelected = isSelected == true
	self.isEnabled = isEnabled == true
	self.clickCallback = clickCallback
	self.fields.icon:setIcon(publicRead.getIcon(self.itemID))
	self.controllers.ctrlSelect:setSelectedIndex(self.isSelected and 1 or 0)
	self.fields.n0:setColor(self.isSelected and cc.c3b(255, 231, 114) or cc.c3b(255, 255, 255))
	self:setGrayed(not self.isEnabled)
end
function BtnConsumable:onClickItem()
	if not self.isEnabled then
		return
	end
	SoraDPlaySound()
	if self.clickCallback then
		self.clickCallback(self.itemID)
	end
end
return BtnConsumable
