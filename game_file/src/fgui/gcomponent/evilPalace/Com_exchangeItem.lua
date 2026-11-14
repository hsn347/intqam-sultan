local publicRead = include("publicRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_exchangeItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://evilPalace/Com_exchangeItem", Com_exchangeItem)
function Com_exchangeItem:onInit()
end
function Com_exchangeItem:onShow()
end
function Com_exchangeItem:initData(data)
	self.fields.icon:setSpriteFrame(publicRead.getIcon(data.id))
	local haveItemNum = backpackCtrl:getItemCount(data.id)
	self.fields.title:setString(haveItemNum .. "/" .. data.count)
	self.fields.title:setColor(haveItemNum >= data.count and cc.c3b(112, 199, 35) or cc.c3b(224, 43, 43))
end
return Com_exchangeItem
