local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local UI_Com_have = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Com_have", UI_Com_have)
fgui.register_extension("ui://CommonUI/UI_Com_have2", UI_Com_have)
fgui.register_extension("ui://CommonUI/UI_Com_have_reddot", UI_Com_have)
function UI_Com_have:onInit()
	self.fields.Button_add:addClickListener(handler(self, self.onClickAdd))
	self.fields.title:fixPos()
	self.fields.icon:fixPos()
	self.fields.Button_add:fixPos()
	if self.fields.Label_reddot then
		self.fields.Label_reddot:fixPos()
	end
end
function UI_Com_have:onShow()
end
function UI_Com_have:initData(itemID, addCallback)
	self.itemID = itemID
	if addCallback then
		self:setAddCallBack(addCallback)
	end
	self:setIcon(publicRead.getIcon(itemID))
	self:updateNum()
end
function UI_Com_have:setAddCallBack(addCallback)
	self.addCallback = addCallback
end
function UI_Com_have:updateNum(value)
	local num = value or backpackCtrl:getItemCount(self.itemID)
	self.fields.title:setString(string.formatnumberthousands(num))
	return num
end
function UI_Com_have:setNum(value)
	self.fields.title:setString(value)
end
function UI_Com_have:setTitleColor(color)
	self.fields.title:setColor(color)
end
function UI_Com_have:hideBtnAdd()
	self.fields.Button_add:setVisible(false)
end
function UI_Com_have:onClickAdd()
	SoraDPlaySound()
	if self.addCallback then
		self.addCallback()
	else
		_ENV = nil
		;(nil).itemID = self.itemID
		uiManager:show("CommonSourceGuide", nil)
	end
end
return UI_Com_have
