local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local UI_Lab_item = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonUI/UI_Lab_item", UI_Lab_item)
function UI_Lab_item:onInit()
	self:fixChildrenPos()
end
function UI_Lab_item:onShow()
end
function UI_Lab_item:initData(id, count, char)
	self.fields.icon:setVisible(true)
	self.fields.icon:setSpriteFrame(publicRead.getIcon(id))
	local char = char or "x"
	if type(char) == "string" then
		self.fields.title:setString(char .. string.formatnumberthousands(count))
	else
		self.fields.title:setString(string.formatnumberthousands(count))
	end
end
function UI_Lab_item:setString(str)
	self.fields.icon:setVisible(true)
	self.fields.title:setString(str)
	self:setWidth(self.fields.title:getWidth() + self.fields.icon:getWidth() * self.fields.icon:getScaleX() + 6)
end
function UI_Lab_item:setStrOnly(str)
	self.fields.icon:setVisible(false)
	self.fields.title:setString(str)
	self:setWidth(self.fields.title:getWidth())
end
function UI_Lab_item:setIconScale(scale)
	self.fields.icon:setScale(scale)
end
function UI_Lab_item:setTitleMaxSize(maxWidth, maxHeight)
	local limitSize = cc.size(maxWidth, maxHeight or self.fields.title:getHeight())
	fguiHelper.setTextWidthHeight(self.fields.title, limitSize)
end
return UI_Lab_item
