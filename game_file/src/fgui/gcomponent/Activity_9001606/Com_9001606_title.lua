local baseComponent = require("fgui.base.baseComponent")
local Com_9001606_title = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001606/Com_9001606_title", Com_9001606_title)
function Com_9001606_title:onInit()
	self.fields.Sprite_arr:fixPos()
	self.fields.Text_title:fixPos()
	self.fields.Button_single:addClickEventListener(handler(self, self.onClicked))
end
function Com_9001606_title:onShow()
end
function Com_9001606_title:initData(title, index, callback)
	self.fields.Text_title:setString(title)
	self.clickIndex = index
	self.clickCallback = callback
end
function Com_9001606_title:setIsSelected(value)
	self.isSelected = value
	self.fields.Sprite_arr:setRotation(self.isSelected and 0 or 90)
end
function Com_9001606_title:onClicked()
	SoraDPlaySound()
	self:setIsSelected(not self.isSelected)
	if self.clickCallback then
		self.clickCallback(self.isSelected, self.clickIndex)
	end
end
return Com_9001606_title
