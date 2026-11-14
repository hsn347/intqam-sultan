local BaseText = require("midware.baseComponent.BaseText")
local BaseInput = fgui.extension_class("BaseInput", fgui.GLabel, BaseText)
fgui.register_extension("ui://Base/BaseInput", BaseInput)
function BaseInput:ctor()
	self.__title = self:getChild("title")
end
function BaseInput:create(size, normalSprite, txtType)
	local input = fgui.UIPackage.CreateObject1("Base", "BaseInput")
	input.isCocos = true
	input:setPosition(0, 0)
	input:setSize(size.width, size.height)
	input:setFontSize(size.height * 2 / 3)
	self.__icon = input:getChild("icon")
	self.__icon:loadTexture(normalSprite, txtType)
	self.__icon:setScale9Enabled(true)
	SoraDSetupEmojies(input.__title)
	return input
end
function BaseInput:addEventListener(...)
	return self.__title:addEventListener(...)
end
function BaseInput:getDescription()
	return self.__title:getDescription()
end
function BaseInput:getMaxLength()
	return self.__title:getMaxLength()
end
function BaseInput:getPlaceHolder()
	return self.__title:getPlaceHolder()
end
function BaseInput:registerScriptEditBoxHandler(handler)
	return self.__title:registerScriptEditBoxHandler(function(event, target)
		handler(event, self)
	end)
end
function BaseInput:setInputFlag(inputFlag)
	return self.__title:setInputFlag(inputFlag)
end
function BaseInput:setInputMode(inputMode)
	return self.__title:setInputMode(inputMode)
end
function BaseInput:setMaxLength(maxLength)
	return self.__title:setMaxLength(maxLength)
end
function BaseInput:setPlaceHolder(pText)
	return self.__title:setPlaceHolder(pText)
end
function BaseInput:setPlaceholderFontColor(color)
	return self.__title:setPlaceholderFontColor(color)
end
function BaseInput:setPlaceholderFontSize(fontSize)
	return self.__title:setPlaceholderFontSize(fontSize)
end
function BaseInput:touchDownAction(sender, controlEvent)
	return self.__title:touchDownAction(sender, controlEvent)
end
function BaseInput:setFontColor(color)
	self.__title:setColor(color)
end
function BaseInput:closeKeyboard(...)
	return self.__title:closeKeyboard(...)
end
function BaseInput:getCharCount(...)
	return self.__title:getCharCount(...)
end
function BaseInput:setControlType(_type)
	self.__title:setControlType(_type)
end
return BaseInput
