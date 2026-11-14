local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_have = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Com_have", Com_have)
fgui.register_extension("ui://CommonNew/Com_have2", Com_have)
function Com_have:onInit()
	self.fields.Button_add:addClickEventListener(handler(self, self.onClickAdd))
	self.fields.title:fixPos()
	self.fields.icon:fixPos()
	self.fields.Button_add:fixPos()
end
function Com_have:onClickAdd()
	if self.addCallback then
		self.addCallback()
	else
		SoraDPlaySound()
		_ENV = nil
		;(nil).itemID = self.itemID
		uiManager:show("CommonSourceGuide", nil)
	end
end
function Com_have:onShow()
end
function Com_have:initData(itemID)
	self.itemID = itemID
	self:setIcon(publicRead.getIcon(itemID))
end
function Com_have:updateNum(value)
	local num = value or publicUtil.getCount(self.itemID)
	self:setText(string.formatnumberthousands(num))
	return num
end
function Com_have:updateNumTitle(str)
	self:setText(str)
end
function Com_have:setAddCallback(cb)
	self.addCallback = cb
end
function Com_have:hideBtnAdd()
	self.fields.Button_add:setVisible(false)
end
return Com_have
