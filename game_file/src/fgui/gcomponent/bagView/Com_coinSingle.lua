local publicUtil = include("publicUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_coinSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://bagView/Com_coinSingle", Com_coinSingle)
function Com_coinSingle:onInit()
	self.fields.bg:fix()
	self.fields.title:fixPos()
	self.fields.Com_item:fixPos()
end
function Com_coinSingle:onShow()
end
function Com_coinSingle:initData(itemID)
	self.fields.Com_item:initData(itemID)
	self.fields.title:setString(string.formatnumberthousands(publicUtil.getCount(itemID)))
end
return Com_coinSingle
